//
//  ValidateModel.swift
//  Remises-RC
//
//  Created by juan ledesma on 1/25/19.
//  Copyright © 2019 umbraApps. All rights reserved.
//

import Foundation

struct ValidateModel : Codable {
    let status : Int
    let login : Int
    let codigo : String
    let nombre : String
    let formapago : String
    let adicional : String
    let precio_km : String
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case login = "login"
        case codigo = "codigo"
        case nombre = "nombre"
        case formapago = "formapago"
        case adicional = "adicional"
        case precio_km = "precio_km"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status) ?? 0
        login = try values.decodeIfPresent(Int.self, forKey: .login) ?? 0
        codigo = try values.decodeIfPresent(String.self, forKey: .codigo) ?? ""
        nombre = try values.decodeIfPresent(String.self, forKey: .nombre) ?? ""
        formapago = try values.decodeIfPresent(String.self, forKey: .formapago) ?? ""
        adicional = try values.decodeIfPresent(String.self, forKey: .adicional) ?? ""
        precio_km = try values.decodeIfPresent(String.self, forKey: .precio_km) ?? ""
    }
    
}
