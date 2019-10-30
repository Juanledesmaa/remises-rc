//
//  UpdateService.swift
//  Remises-RC
//
//  Created by juan ledesma on 1/28/19.
//  Copyright © 2019 umbraApps. All rights reserved.
//

import Foundation
import Alamofire
import Firebase

private enum EndPointUpdateToken: String {
    case update = "token_actualizar.php"
}

protocol UpdateServiceProtocol: Service {
    func updateFirebaseToken(completion: @escaping (Bool, Error?) -> Void)
}

final class UpdateService: UpdateServiceProtocol {
    func updateFirebaseToken(completion: @escaping (Bool, Error?) -> Void) {
        
        var token = ""
        
        InstanceID.instanceID().instanceID(handler: { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
                return
                
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                token = result.token
                
                let defaults = UserDefaults.standard
                let clave = defaults.string(forKey: defaultsKeys.keyClave) ?? ""
                let empresa = defaults.string(forKey: defaultsKeys.keyEmpresa) ?? ""
                let celular = defaults.string(forKey: defaultsKeys.keyCelular) ?? ""
                
                NetworkManager.manager.request(ServiceBaseUrl.pushUrl + EndPointUpdateToken.update.rawValue, method: .get, parameters: ["empresa" : empresa, "celular" : celular, "clave" : clave, "token": token]).responseJSON { response in
                    
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
        })   
    }
}
