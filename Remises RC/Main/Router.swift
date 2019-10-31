//
//  Router.swift
//  Remises-RC
//
//  Created by juan ledesma on 1/25/19.
//  Copyright © 2019 umbraApps. All rights reserved.
//

import Foundation
import UIKit

class Router: NSObject {
    
    private static var window: UIWindow? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.window
    }
    
    static func setRootViewController(viewController: UIViewController) {
        
        let navigationController = UINavigationController()
        navigationController.viewControllers = [viewController]
        window?.rootViewController = navigationController
    }

    @discardableResult
    static func presentMainViewController(fromLogin: Bool? = nil) -> ValidateViewController {
        let vc = ValidateViewController()
        let service: ValidateServiceProtocol? = ServiceLocator.sharedInstance.get(service: ValidateServiceProtocol.self)
        vc.viewModel = RequestViewModel(view: vc, service: service)
        NavStyle.setupNavBarAppearance()
        setRootViewController(viewController: vc)
        
        return vc
    }
    
    static func presentWebViewController() {
        let vc = WebViewViewController()
        let service: UpdateServiceProtocol? = ServiceLocator.sharedInstance.get(service: UpdateServiceProtocol.self)
        let chatService: ChatServiceProtocol? = ServiceLocator.sharedInstance.get(service: ChatServiceProtocol.self)
        vc.viewModel = WebViewViewModel(view: vc, service: service)
        vc.chatViewModel = ChatViewModel(view: vc, service: nil, chatService: chatService)
        NavStyle.setupNavBarAppearance()
        setRootViewController(viewController: vc)
    }
    
    @discardableResult
    static func presentLoginViewController() -> LoginViewController {
        let vc = LoginViewController()
        let service: ValidateServiceProtocol? = ServiceLocator.sharedInstance.get(service: ValidateServiceProtocol.self)
        vc.viewModel = RequestViewModel(view: vc, service: service)
        NavStyle.setupNavBarAppearance()
        setRootViewController(viewController: vc)
        
        return vc

    }
    
    static func pushSMSViewController(viewController: UIViewController, model: ValidateCodeModel?) {
        let vc = SMSViewController()
        let service: ValidateServiceProtocol? = ServiceLocator.sharedInstance.get(service: ValidateServiceProtocol.self)
        vc.viewModel = RequestViewModel(view: vc, service: service)
        vc.model = model
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
}
