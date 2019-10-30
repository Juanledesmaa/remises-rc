//
//  WebViewViewModel.swift
//  Remises-RC
//
//  Created by juan ledesma on 1/28/19.
//  Copyright © 2019 umbraApps. All rights reserved.
//

import Foundation

protocol WebViewViewModelView: BaseViewModel {
    func showUpdatedToken(response: Bool)
}

protocol WebViewViewModelDelegate {
    func getUpdateFirebaseToken()
}

class WebViewViewModel: WebViewViewModelDelegate {

    weak var view: WebViewViewModelView?
    var service: UpdateServiceProtocol?
    
    init(view: WebViewViewModelView?, service: UpdateServiceProtocol?) {
        self.view = view
        self.service = service
    }
    
    func getUpdateFirebaseToken() {
        self.view?.showLoader()
        service?.updateFirebaseToken(completion: { (response, error) in
            self.view?.hideLoader()
            if error != nil {
                self.view?.showAlert(title: "Error", message: "Ha ocurrido un error")
            } else {
                self.view?.showUpdatedToken(response: response)
            }
        })
    }

}

