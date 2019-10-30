//
//  LoginViewController.swift
//  Remises-RC
//
//  Created by juan ledesma on 1/25/19.
//  Copyright © 2019 umbraApps. All rights reserved.
//

import UIKit
import Foundation
import SkyFloatingLabelTextField

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var txtNombre: SkyFloatingLabelTextField!
    @IBOutlet weak var txtCelular: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var btnIngresar: UIButton!
    var viewModel: RequestViewModelDelegate?
    
    var request: RequestCodeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Ingrese"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Regresar"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setDelegates() {
        self.txtNombre.delegate = self
        self.txtCelular.delegate = self
        self.txtEmail.delegate = self
        
        self.txtNombre.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
        self.txtCelular.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
        self.txtEmail.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
    }
    
    @IBAction func btnIngresarPressed(_ sender: UIButton) {

        guard self.txtNombre.text != "" else {
            self.txtNombre.errorMessage = "El nombre no puede estar vacio"
            return
        }
        
        self.txtNombre.errorMessage = ""
        
        guard self.txtCelular.text != "" else {
            self.txtCelular.errorMessage = "Ingrese el numero de telefono"
            return
        }
        
        self.txtCelular.errorMessage = ""
        
        guard self.txtEmail.text != "" else {
            self.txtEmail.errorMessage = "Ingrese el Email"
            return
        }
        
        self.txtEmail.errorMessage = ""
        
        self.request = RequestCodeModel.init(empresa: "256", nombre: self.txtNombre.text!, celular: self.txtCelular.text!)
        self.viewModel?.getRequestCode(requestCodeModel: self.request)
        
    }
    
}

extension LoginViewController: RequestViewModelView {
    func showValidateSMS(response: ValidateModel?) {
    }
    
    func showCode(response: String?) {
        if response != nil {
            Router.pushSMSViewController(viewController: self, model: ValidateCodeModel.init(empresa: self.request?.empresa ?? "", celular: self.request?.celular ?? "", clave: ""))
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.characters.count)! > 0  {
            self.btnIngresar.isEnabled = true
            self.btnIngresar.alpha = 1.0
        } else {
            self.btnIngresar.isEnabled = false
            self.btnIngresar.alpha = 0.5
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //12 Digitos numero argentino
        switch textField {
        case self.txtCelular:
            guard let text = textField.text else { return true }
            let count = text.count + string.count - range.length
            return count <= 10
        default:
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textfieldDidChange(_ textfield: UITextField) {
        switch textfield {
        case self.txtEmail:
            guard let text = textfield.text else {
                return
            }
            
            if text.isValidEmail() {
                self.txtEmail.errorMessage = ""
            } else {
                self.txtEmail.errorMessage = "Ingrese un email valido"
            }
            
            break
        case self.txtCelular:
            guard let text = textfield.text else {
                return
            }
            
            if text.characters.count < 10 {
                self.txtCelular.errorMessage = "Ingrese un telefono valido"
            } else {
                self.txtCelular.errorMessage = ""
            }
            
            break
        case self.txtNombre:
            guard let text = textfield.text else {
                return
            }
            
            if text.characters.count < 3 {
                self.txtNombre.errorMessage = "Ingrese un nombre"
            } else {
                self.txtNombre.errorMessage = ""
            }
            break
        default:
            break
        }
    }
}
