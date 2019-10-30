//
//  RequestCodeModel.swift
//  Remises-RC
//
//  Created by juan ledesma on 1/25/19.
//  Copyright © 2019 umbraApps. All rights reserved.
//

import Foundation

struct RequestCodeModel: Decodable {
    let empresa: String
    let nombre: String
    let celular: String
    
    init(empresa: String, nombre: String, celular: String) {
        self.empresa = empresa
        self.nombre = nombre
        self.celular = celular
    }
}
