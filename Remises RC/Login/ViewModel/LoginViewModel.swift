//
//  LoginViewModel.swift
//  Remises-RC
//
//  Created by juan ledesma on 1/25/19.
//  Copyright © 2019 umbraApps. All rights reserved.
//

import Foundation

protocol LoginViewModelView: BaseViewModel {
    func showValidateCode()
}

protocol LoginViewModelDelegate {
    func getValidateCode(request: RequestCodeModel?)
}

class LoginViewModel: LoginViewModelDelegate {
    weak var view: LoginViewModelView?
    var service: ValidateServiceProtocol?
    
    init(view: LoginViewModelView, service: ValidateServiceProtocol?) {
        self.view = view
        self.service = service
    }
    
    func getValidateCode(request: RequestCodeModel?) {
        self.view?.showLoader()
        service?.getRequestSMS(requestCodeModel: request, completion: {
            (response, error) in
            self.view?.hideLoader()
            
            if error != nil {
                self.view?.showAlert(title: "Error", message: "Ha ocurrido un error en la operacion")
            } else {
                guard response != nil else { return }
                self.view?.showValidateCode()
            }
        })
    }
    
}
