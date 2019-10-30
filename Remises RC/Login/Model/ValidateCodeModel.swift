//
//  ValidateCodeModel.swift
//  Remises-RC
//
//  Created by juan ledesma on 1/25/19.
//  Copyright © 2019 umbraApps. All rights reserved.
//

import Foundation

struct ValidateCodeModel: Decodable {
    var empresa: String
    var celular: String
    var clave: String
    
    init(empresa: String, celular: String, clave: String) {
        self.empresa = empresa
        self.clave = clave
        self.celular = celular
    }
}
