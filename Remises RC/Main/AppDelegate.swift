//
//  AppDelegate.swift
//  Remises-RC
//
//  Created by juan ledesma on 1/24/19.
//  Copyright © 2019 umbraApps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        
        IQKeyboardManager.shared.enable = true
        window = UIWindow(frame:UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        self.validateActualToken()

        return true
    }
    
    private func validateActualToken() {
        let defaults = UserDefaults.standard
        defaults.string(forKey: "clave") == nil ? Router.presentLoginViewController() : Router.presentMainViewController()
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        //        if let messageID = userInfo[gcmMessageIDKey] {
        //            print("Message ID: \(messageID)")
        //        }
        
        // Print full message.
        print(userInfo)
    }
    
    private func topViewControllerWithRootViewController(rootViewController: UIViewController!) -> UIViewController? {
        if (rootViewController == nil) { return nil }
        if (rootViewController.isKind(of: UITabBarController.self)) {
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UITabBarController).selectedViewController)
        } else if (rootViewController.isKind(of: UINavigationController.self)) {
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UINavigationController).visibleViewController)
        } else if (rootViewController.presentedViewController != nil) {
            return topViewControllerWithRootViewController(rootViewController: rootViewController.presentedViewController)
        }
        return rootViewController
    }

    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        //        if let messageID = userInfo[gcmMessageIDKey] {
        //            print("Message ID: \(messageID)")
        //        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
        
        InstanceID.instanceID().instanceID(handler: { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
                
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                
                
            }
        })
    }

}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //ALERT DESDE APP EN ESTADO ACTIVA
        let userInfo : NSDictionary = notification.request.content.userInfo as NSDictionary
        let comando = getComandoNotification(userInfo: userInfo)

        
        if let rootViewController = self.topViewControllerWithRootViewController(rootViewController: window?.rootViewController) {
            
            for viewController in rootViewController.children {
                // some process
                switch viewController {
                case is MovilAsignadoViewController:
                    viewController.willMove(toParent: nil)
                    viewController.view.removeFromSuperview()
                    viewController.removeFromParent()
                    break
                case is MensajeAlertViewController:
                    viewController.willMove(toParent: nil)
                    viewController.view.removeFromSuperview()
                    viewController.removeFromParent()
                    break
                case is RatingAlertViewController:
                    viewController.willMove(toParent: nil)
                    viewController.view.removeFromSuperview()
                    viewController.removeFromParent()
                    break
                default:
                    break
                }
            }

            
            switch comando {
            case "asignacion":
                let dataNotification = getDataAsignacion(userInfo: userInfo)
                let vc = MovilAsignadoViewController()
                vc.view.frame = rootViewController.view.frame
                rootViewController.addChild(vc)
                rootViewController.view.addSubview(vc.view)
                vc.lblMovil.text = dataNotification?.movil
                vc.lblMarca.text = dataNotification?.marca
                vc.lblChofer.text = dataNotification?.chofer_nombre
                vc.lblPatente.text = dataNotification?.patente

                let message: [String: Any] = ["chat": []]
                NotificationCenter.default.post(name: .showChatViewController, object: nil, userInfo: message)
                break
            case "viaje_posicion":
                //PENDIENTE
                break
            case "en_puerta":
                let message = getDataChat(userInfo: userInfo)
                let vc = MensajeAlertViewController()
                vc.view.frame = rootViewController.view.frame
                rootViewController.addChild(vc)
                rootViewController.view.addSubview(vc.view)
                vc.lblMensaje.text = message
                break
            case "viaje_finalizado":
//                let message = getDataChat(userInfo: userInfo)
                let vc = RatingAlertViewController()
                vc.view.frame = rootViewController.view.frame
                rootViewController.addChild(vc)
                rootViewController.view.addSubview(vc.view)
                vc.lblTitle.text = "Viaje Finalizado"
                NotificationCenter.default.post(name: .reloadURL, object: nil)
                break
            case "mensaje":
                let message = getDataChat(userInfo: userInfo)
                let vc = MensajeAlertViewController()
                vc.view.frame = rootViewController.view.frame
                rootViewController.addChild(vc)
                rootViewController.view.addSubview(vc.view)
                vc.lblMensaje.text = message
                break
            case "chat":
                let chatMessage = getDataChat(userInfo: userInfo)
                let message: [String: Any] = ["message": chatMessage ?? ""]
                NotificationCenter.default.post(name: .showChatViewController, object: nil, userInfo: message)
                break
            default:
                break
            }
        }

        // Change this to your preferred presentation option
        completionHandler([.alert,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        //ALERT DESDE APP EN BACKGROUND
        let userInfo : NSDictionary = response.notification.request.content.userInfo as NSDictionary
        
        let state = UIApplication.shared.applicationState
        if state == .background  || state == .inactive{
            // background
            let comando = getComandoNotification(userInfo: userInfo)
            
            
            if let rootViewController = self.topViewControllerWithRootViewController(rootViewController: window?.rootViewController) {
                
                for viewController in rootViewController.children {
                    // some process
                    switch viewController {
                    case is MovilAsignadoViewController:
                        viewController.willMove(toParent: nil)
                        viewController.view.removeFromSuperview()
                        viewController.removeFromParent()
                        break
                    case is MensajeAlertViewController:
                        viewController.willMove(toParent: nil)
                        viewController.view.removeFromSuperview()
                        viewController.removeFromParent()
                        break
                    case is RatingAlertViewController:
                        viewController.willMove(toParent: nil)
                        viewController.view.removeFromSuperview()
                        viewController.removeFromParent()
                        break
                    default:
                        break
                    }
                }
                
                switch comando {
                case "asignacion":
                    let dataNotification = getDataAsignacion(userInfo: userInfo)
                    let vc = MovilAsignadoViewController()
                    vc.view.frame = rootViewController.view.frame
                    rootViewController.addChild(vc)
                    rootViewController.view.addSubview(vc.view)
                    vc.lblMovil.text = dataNotification?.movil
                    vc.lblMarca.text = dataNotification?.marca
                    vc.lblChofer.text = dataNotification?.chofer_nombre
                    vc.lblPatente.text = dataNotification?.patente
                    
                    let message: [String: Any] = ["chat": []]
                    NotificationCenter.default.post(name: .showChatViewController, object: nil, userInfo: message)
                    break
                case "viaje_posicion":
                    //PENDIENTE
                    break
                case "en_puerta":
                    let message = getDataChat(userInfo: userInfo)
                    let vc = MensajeAlertViewController()
                    vc.view.frame = rootViewController.view.frame
                    rootViewController.addChild(vc)
                    rootViewController.view.addSubview(vc.view)
                    vc.lblMensaje.text = message
                    break
                case "viaje_finalizado":
                    //                let message = getDataChat(userInfo: userInfo)
                    let vc = RatingAlertViewController()
                    vc.view.frame = rootViewController.view.frame
                    rootViewController.addChild(vc)
                    rootViewController.view.addSubview(vc.view)
                    vc.lblTitle.text = "Viaje Finalizado"
                    NotificationCenter.default.post(name: .reloadURL, object: nil)
                    break
                case "mensaje":
                    let message = getDataChat(userInfo: userInfo)
                    let vc = MensajeAlertViewController()
                    vc.view.frame = rootViewController.view.frame
                    rootViewController.addChild(vc)
                    rootViewController.view.addSubview(vc.view)
                    vc.lblMensaje.text = message
                    break
                case "chat":
                    let chatMessage = getDataChat(userInfo: userInfo)
                    let message: [String: Any] = ["message": chatMessage ?? ""]
                    NotificationCenter.default.post(name: .showChatViewController, object: nil, userInfo: message)
                    break
                default:
                    break
                }
            }
            
            
        } else if state == .active {
            
        }
        
        completionHandler()
    }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}


