//
//  SendMessageService.swift
//  Remises-RC
//
//  Created by juan ledesma on 1/31/19.
//  Copyright © 2019 umbraApps. All rights reserved.
//

import Foundation
import Alamofire
import Firebase

private enum EndPointSendMessage: String {
    case send = "chat.php"
}

protocol SendMessageProtocol: Service {
    func sendMessage(message: String, completion: @escaping (Bool, Error?) -> Void)
}

final class SendMessageService: SendMessageProtocol {
    func sendMessage(message: String, completion: @escaping (Bool, Error?) -> Void) {
        
        let defaults = UserDefaults.standard
        let clave = defaults.string(forKey: defaultsKeys.keyClave) ?? ""
        let empresa = defaults.string(forKey: defaultsKeys.keyEmpresa) ?? ""
        let celular = defaults.string(forKey: defaultsKeys.keyCelular) ?? ""
        
        
        NetworkManager.manager.request(ServiceBaseUrl.baseUrl + EndPointSendMessage.send.rawValue, method: .get, parameters: ["empresa" : empresa, "celular" : celular, "clave" : clave, "mensaje" : message]).responseJSON { response in

            if response.response?.statusCode == StatusCodes.ok {
                switch response.result {
                case .success:
                    completion(true, nil)
                    break
                case .failure(let error):
                    completion(false, error)
                    break
                }

            } else {
                completion(false, response.result.error)
            }
        }
    }
}
