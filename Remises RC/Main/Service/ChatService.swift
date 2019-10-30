//
//  ChatService.swift
//  Remises-RC
//
//  Created by juan ledesma on 2/4/19.
//  Copyright © 2019 umbraApps. All rights reserved.
//

import Foundation
import Alamofire
import Firebase

private enum EndPointChat: String {
    case get = "chat.php"
}

protocol ChatServiceProtocol: Service {
    func loadChat(completion: @escaping (Bool, Error?) -> Void)
}

final class ChatService: ChatServiceProtocol {
    
    func loadChat(completion: @escaping (Bool, Error?) -> Void) {
        
        let defaults = UserDefaults.standard
        let clave = defaults.string(forKey: defaultsKeys.keyClave) ?? ""
        let empresa = defaults.string(forKey: defaultsKeys.keyEmpresa) ?? ""
        let celular = defaults.string(forKey: defaultsKeys.keyCelular) ?? ""

        NetworkManager.manager.request(ServiceBaseUrl.baseUrl + EndPointChat.get.rawValue, method: .get, parameters: ["empresa" : empresa, "celular" : celular, "clave" : clave]).responseJSON { response in
            
            if response.response?.statusCode == StatusCodes.ok {
                switch response.result {
                case .success:
                    print(response.result.value as? NSDictionary ?? [:])
                    
                    let value = response.result.value as? NSDictionary ?? [:]
                    if let chat = value["chat"] {

                        print(chat)
                        completion(true, nil)

                    } else {

                     completion(false, nil)
                    }

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
