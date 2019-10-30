//
//  SMSViewController.swift
//  Remises-RC
//
//  Created by juan ledesma on 1/25/19.
//  Copyright © 2019 umbraApps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SMSViewController: BaseViewController {
    
    var viewModel: RequestViewModelDelegate?
    @IBOutlet weak var txtCode: SkyFloatingLabelTextField!
    @IBOutlet weak var btnIngresar: UIButton!
    
    var model: ValidateCodeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Ingrese"
        self.showCustomLoader()
        self.txtCode.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.hideCustomLoader()
        })
    }
    
    @IBAction func btnIngresarPressed(_ sender: UIButton) {
        if (self.txtCode.text?.characters.count)! > 0  {
            self.txtCode.errorMessage = ""
            model?.clave = self.txtCode.text ?? ""
            
            self.viewModel?.validateSMS(model: model)
        } else {
            self.txtCode.errorMessage = "Ingrese la clave"
            
        }
        
        
    }
    
}

extension SMSViewController: RequestViewModelView {
    func showValidateSMS(response: ValidateModel?) {
        
        
        if response?.status != 200 || response?.login != 200 {
            
        } else {
            let defaults = UserDefaults.standard
            defaults.set("256" , forKey: defaultsKeys.keyEmpresa)
            defaults.set(model?.clave, forKey: defaultsKeys.keyClave)
            defaults.set(model?.celular, forKey: defaultsKeys.keyCelular)
            Router.presentMainViewController()
        }
        
    }
    
    func showCode(response: String?) {
    }
    
}

extension SMSViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.characters.count)! > 0  {
            self.txtCode.errorMessage = ""
        } else {
            self.txtCode.errorMessage = "Ingrese la clave"
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //12 Digitos numero argentino
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
