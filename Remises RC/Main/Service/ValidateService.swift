//
//  ValidateService.swift
//  Remises-RC
//
//  Created by juan ledesma on 1/25/19.
//  Copyright © 2019 umbraApps. All rights reserved.
//

import Foundation
import Alamofire

private enum EndPointValidate: String {
    case validate = "validar_claves.php"
    case request = "solicitar_sms.php"
}

protocol ValidateServiceProtocol: Service {
    func getValidateCode(validateCodeModel: ValidateCodeModel?, completion: @escaping (ValidateModel?, Error?) -> Void)
    func getRequestSMS(requestCodeModel: RequestCodeModel?, completion: @escaping (String?, Error?) -> Void)
}

final class ValidateService: ValidateServiceProtocol {
    func getValidateCode(validateCodeModel: ValidateCodeModel?, completion: @escaping (ValidateModel?, Error?) -> Void) {
        
        var resultModel : ValidateModel?
        NetworkManager.manager.request(ServiceBaseUrl.baseUrl + EndPointValidate.validate.rawValue, method: .get, parameters: ["empresa" : "256", "celular" : validateCodeModel?.celular ?? "", "clave" : validateCodeModel?.clave ?? ""]).responseJSON { response in
            
            if response.response?.statusCode == StatusCodes.ok {
                
                switch response.result {
                    
                case .success:
                    
                    do {
                        let jsonDecoder = JSONDecoder()
                        let responseModel = try jsonDecoder.decode(ValidateModel.self, from: response.data ?? Data())
                        resultModel = responseModel
                        
                    } catch let parseError as NSError {
                        print("JSON Error \(parseError.localizedDescription)")
                    }
                    
                    completion(resultModel, nil)
                    break
                case .failure(let error):
                    completion(nil, error)
                    break
                }
                
            } else {
                completion(nil, response.result.error)
            }
        }
    }
    
    func getRequestSMS(requestCodeModel: RequestCodeModel?, completion: @escaping (String?, Error?) -> Void) {
        
        NetworkManager.manager.request(ServiceBaseUrl.baseUrl + EndPointValidate.request.rawValue, method: .get, parameters: ["empresa" : "256", "nombre" : requestCodeModel?.nombre ?? "" , "celular" : requestCodeModel?.celular ?? ""]).responseString { response in
            
            if response.response?.statusCode == StatusCodes.ok {
                switch response.result {
                    
                case .success:
                    completion(response.value ?? "", nil)
                    break
                case .failure(let error):
                    completion(nil, error)
                    break
                }
                
            } else {
                completion(nil, response.result.error)
            }
            
        }
        
    }
}
