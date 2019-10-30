//
//  Service.swift
//  Remises-RC
//
//  Created by juan ledesma on 1/25/19.
//  Copyright © 2019 umbraApps. All rights reserved.
//

import Foundation
import Alamofire

enum ApiError: Error {
    case parsingError
    case dataError
    case serverError
}

protocol Service {
    var baseURL: String { get }
    var header: HTTPHeaders { get }
}

extension Service {
    var baseURL: String {
        return ServiceBaseUrl.baseUrl
    }
    
    var header: HTTPHeaders { return ["Content-Type": "application/json"] }
}
