//
//  ValidateViewController.swift
//  Remises-RC
//
//  Created by juan ledesma on 1/25/19.
//  Copyright © 2019 umbraApps. All rights reserved.
//

import UIKit

class ValidateViewController: BaseViewController {
    
    @IBOutlet weak var LblIniciando: UILabel!
    var viewModel: RequestViewModelDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Ingrese"
        self.startLoading()
        self.checkService()
        
        
    }
    
    private func checkService() {
        let defaults = UserDefaults.standard
        let clave = defaults.string(forKey: defaultsKeys.keyClave)
        let empresa = defaults.string(forKey: defaultsKeys.keyEmpresa)
        let celular = defaults.string(forKey: defaultsKeys.keyCelular)
        self.viewModel?.validateSMS(model: ValidateCodeModel.init(empresa: empresa ?? "", celular: celular ?? "", clave: clave ?? ""))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.LblIniciando.makeLoadingAnimation(text: self.LblIniciando.text ?? "Loading", stop: true)
        
    }
    
    private func startLoading() {
        self.LblIniciando.makeLoadingAnimation(text: self.LblIniciando.text ?? "Loading", stop: false)
        
    }
}

extension ValidateViewController: RequestViewModelView {
    func showValidateSMS(response: ValidateModel?) {
        
        if response?.status != 200 || response?.login != 200 {
            Router.presentLoginViewController()
        } else {
            Router.presentWebViewController()
        }
    }
    
    func showCode(response: String?) {
    }
    
}
