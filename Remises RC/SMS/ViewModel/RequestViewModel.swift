//
//  RequestViewModel.swift
//  Remises-RC
//
//  Created by juan ledesma on 1/25/19.
//  Copyright © 2019 umbraApps. All rights reserved.
//

import Foundation

protocol RequestViewModelView: BaseViewModel {
    func showCode(response: String?)
    func showValidateSMS(response: ValidateModel?)
}

protocol RequestViewModelDelegate {
    func getRequestCode(requestCodeModel: RequestCodeModel?)
    func validateSMS(model: ValidateCodeModel?)
}

class RequestViewModel: RequestViewModelDelegate {
    weak var view: RequestViewModelView?
    var service: ValidateServiceProtocol?
    
    init(view: RequestViewModelView?, service: ValidateServiceProtocol?) {
        self.view = view
        self.service = service
    }
    
    func getRequestCode(requestCodeModel: RequestCodeModel?) {
        self.view?.showLoader()
        service?.getRequestSMS(requestCodeModel: requestCodeModel, completion: {
            (response, error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                self.view?.hideLoader()
            })
            
            if error != nil {
                self.view?.showAlert(title: "Error", message: "Ha ocurrido un error al enviar el mensaje intente nuevamente")
            } else {
                guard response != nil else { return }
                self.view?.showCode(response: response ?? nil)
            }
        })
    }
    
    func validateSMS(model: ValidateCodeModel?) {
        self.view?.showLoader()
        service?.getValidateCode(validateCodeModel: model ?? ValidateCodeModel.init(empresa: "", celular: "", clave: ""), completion: { (response, error) in
            self.view?.hideLoader()
            
            if error != nil {
                self.view?.showAlert(title: "Ha ocurrido un error", message: "Error de servidor")
                
            } else {
                guard response != nil else { return}
                
                if response?.status != 200 || response?.login != 200 {
                    self.view?.showAlert(title: "Error", message: "Error de servidor")
                    self.view?.showValidateSMS(response: response)
                } else {
                    self.view?.showValidateSMS(response: response)
                }
                
                
            }
        })
    }
    
    
}
