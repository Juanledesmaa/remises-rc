//
//  WebViewViewController.swift
//  Remises-RC
//
//  Created by juan ledesma on 1/25/19.
//  Copyright © 2019 umbraApps. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import PullUpController

class WebViewViewController: BaseViewController {
    
    @IBOutlet weak var viewMain: UIView!

    @IBOutlet weak var webView: UIWebView!
    var clave = ""
    var empresa = ""
    var celular = ""
    var locationManager:CLLocationManager!
    var coordinate: CLLocationCoordinate2D?
    var viewModel: WebViewViewModelDelegate?
    var currentChatController: ChatViewController?
    var chatViewModel: ChatViewViewModelDelegate?
    var isReloadURL = false
    
    
    @IBOutlet weak var viewMainBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mapa"
        self.addObservers()
        self.setNavButton()
        self.determineMyCurrentLocation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel?.getUpdateFirebaseToken()

    }

    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.showChatViewController(_:)), name: .showChatViewController, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setReloadTrue(_:)), name: .reloadURL, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadCompleteURL(_:)),   name: .reloadCompleteURL, object: nil)
    }
    
    @objc private func showChatViewController(_ notification: NSNotification) {

        if self.currentChatController != nil {
            guard let dict = notification.userInfo as NSDictionary? else { return }
            if let chat = dict["chat"] {
                let vc = self.currentChatController
                vc?.newChat(data: chat as? NSDictionary)
                
            } else {
                guard let msg = dict["message"] as? String else { return }
                let vc = self.currentChatController
                vc?.onNewMessagedriver(data: msg)
            }

        } else {
            self.viewMainBottomConstraint.constant = 60
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            
            guard let dict = notification.userInfo as NSDictionary? else { return }
            print(dict)
            if let chat = dict["chat"] {
                let pullUpController = ChatViewController()
                let service: SendMessageProtocol? = ServiceLocator.sharedInstance.get(service: SendMessageProtocol.self)
                let chatService: ChatServiceProtocol? = ServiceLocator.sharedInstance.get(service: ChatServiceProtocol.self)
                pullUpController.viewModel = ChatViewModel(view: pullUpController, service: service, chatService: chatService)
                _ = pullUpController.view // call pullUpController.viewDidLoad()
                pullUpController.newChat(data: chat as? NSDictionary)
                addPullUpController(pullUpController,
                                    initialStickyPointOffset: pullUpController.initialPointOffset,
                                    animated: true)
                self.currentChatController = pullUpController

            } else {

                guard let msg = dict["message"] as? String else { return }
                let vc = self.currentChatController
                vc?.onNewMessagedriver(data: msg)
                
                let pullUpController = ChatViewController()
                let service: SendMessageProtocol? = ServiceLocator.sharedInstance.get(service: SendMessageProtocol.self)
                let chatService: ChatServiceProtocol? = ServiceLocator.sharedInstance.get(service: ChatServiceProtocol.self)
                pullUpController.viewModel = ChatViewModel(view: pullUpController, service: service, chatService: chatService)
                _ = pullUpController.view // call pullUpController.viewDidLoad()
                pullUpController.onNewMessagedriver(data: msg)
                addPullUpController(pullUpController,
                                    initialStickyPointOffset: pullUpController.initialPointOffset,
                                    animated: true)
                self.currentChatController = pullUpController
            }
        }
        
    }
    
    private func loadDefaults() {
        let defaults = UserDefaults.standard
        self.clave = defaults.string(forKey: defaultsKeys.keyClave) ?? ""
        self.empresa = defaults.string(forKey: defaultsKeys.keyEmpresa) ?? ""
        self.celular = defaults.string(forKey: defaultsKeys.keyCelular) ?? ""
        self.loadURL()
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            
        }
    }
    
    private func setNavButton() {
        let refreshButton: UIButton = UIButton.init(type: .custom)
        refreshButton.sizeToFit()
        refreshButton.frame.size.width *= Constants.offSetWidth
        refreshButton.frame.size.height *= Constants.offSetHeight
        refreshButton.contentEdgeInsets = Constants.backInsents
        refreshButton.imageView?.contentMode = .scaleAspectFit
        
        let refreshButtonItem: UIBarButtonItem = UIBarButtonItem(customView: refreshButton)
        let currWidth = refreshButtonItem.customView?.widthAnchor.constraint(equalToConstant: 30)
        currWidth?.isActive = true
        let currHeight = refreshButtonItem.customView?.heightAnchor.constraint(equalToConstant: 30)
        currHeight?.isActive = true
        
        refreshButton.addTarget(self, action: #selector(refreshButtonPressed(sender:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem  = refreshButtonItem
        refreshButton.contentHorizontalAlignment = .right
        refreshButton.setImage(Images.refresh, for: .normal)
        
    }
    
    @objc func refreshButtonPressed(sender: UIBarButtonItem) {
        self.reloadURL()
    }

    
    private func loadURL() {
        let url = URL(string: ServiceBaseUrl.baseUrl + "mapa.php?empresa=\(self.empresa)&celular=\(self.celular)&clave=\(self.clave)&latitud=\(self.coordinate?.latitude ?? 0.0)&longitud=\(self.coordinate?.longitude ?? 0.0)")
        self.webView.loadRequest(URLRequest(url: url!))
    }
    
    @objc func setReloadTrue(_ notification: NSNotification) {
        self.isReloadURL = true
        self.viewMainBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        addPullUpController(self.currentChatController!,
                            initialStickyPointOffset: 0,
                            animated: true)
        self.currentChatController?.removeFromParent()
        self.currentChatController?.view.removeFromSuperview()
        self.currentChatController = nil
        self.determineMyCurrentLocation()
        self.reloadURL()
    }
    
    @objc func reloadURL() {
        //        let blankURL = URL(string: "about:blank")
        //        self.webView.loadRequest(URLRequest(url: blankURL!))
        
        let newURL = URL(string: ServiceBaseUrl.baseUrl + "mapa.php?empresa=\(self.empresa)&celular=\(self.celular)&clave=\(self.clave)&latitud=\(self.coordinate?.latitude ?? 0.0)&longitud=\(self.coordinate?.longitude ?? 0.0)&limpiar=SI")
        self.webView.loadRequest(URLRequest(url: newURL!))
        self.isReloadURL = false
        
    }
    
    @objc func reloadCompleteURL(_ notification: NSNotification) {
        //        let blankURL = URL(string: "about:blank")
        //        self.webView.loadRequest(URLRequest(url: blankURL!))
        
        let newURL = URL(string: ServiceBaseUrl.baseUrl + "mapa.php?empresa=\(self.empresa)&celular=\(self.celular)&clave=\(self.clave)&latitud=\(self.coordinate?.latitude ?? 0.0)&longitud=\(self.coordinate?.longitude ?? 0.0)&limpiar=SI")
        self.webView.loadRequest(URLRequest(url: newURL!))
        self.isReloadURL = false
        
        
    }
    
}

extension WebViewViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        self.coordinate = userLocation.coordinate
        if self.isReloadURL {
            self.reloadURL()

        } else {
            self.loadDefaults()
        }
        
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}

extension WebViewViewController: WebViewViewModelView {
    func showUpdatedToken(response: Bool) {

        self.chatViewModel?.loadChat()
    }
}

extension WebViewViewController: ChatViewViewModelView {
    func showChat() {

    }
    
    func showUpdatedMessage() {
        
    }
    
    
}

