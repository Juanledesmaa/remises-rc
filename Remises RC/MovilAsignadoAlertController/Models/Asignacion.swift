//
//  Asignacion.swift
//  Remises-RC
//
//  Created by juan ledesma on 1/31/19.
//  Copyright © 2019 umbraApps. All rights reserved.
//

import Foundation
struct Asignacion : Codable {
    let marca : String
    let patente : String
    let chofer_dni : String
    let chofer_nombre : String
    let latitud : String //PENDIENTE
    let longitud : String //PENDIENTE
    let movil: String
    let noViaje: String

    enum CodingKeys: String, CodingKey {
        case marca = "marca"
        case patente = "patente"
        case chofer_dni = "chofer_dni"
        case chofer_nombre = "chofer_nombre"
        case latitud = "latitud"
        case longitud = "longitud"
        case movil = "movil"
        case noViaje = "noViaje"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        marca = try values.decodeIfPresent(String.self, forKey: .marca) ?? ""
        patente = try values.decodeIfPresent(String.self, forKey: .patente) ?? ""
        chofer_dni = try values.decodeIfPresent(String.self, forKey: .chofer_dni) ?? ""
        chofer_nombre = try values.decodeIfPresent(String.self, forKey: .chofer_nombre) ?? ""
        latitud = try values.decodeIfPresent(String.self, forKey: .latitud) ?? ""
        longitud = try values.decodeIfPresent(String.self, forKey: .longitud) ?? ""
        movil = try values.decodeIfPresent(String.self, forKey: .movil) ?? ""
        noViaje = try values.decodeIfPresent(String.self, forKey: .noViaje) ?? ""
    }
    
}
