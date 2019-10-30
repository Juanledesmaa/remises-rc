//
//  ServiceLocator.swift
//  Remises-RC
//
//  Created by juan ledesma on 1/25/19.
//  Copyright © 2019 umbraApps. All rights reserved.
//

import Foundation

protocol ServiceLocatorProtocol {
    
    func get<T>(service: T.Type) -> T?
}

final class ServiceLocator: ServiceLocatorProtocol {
    static let sharedInstance = ServiceLocator()
    
    func get<T>(service: T.Type) -> T? {
        switch String(describing: service) {
        case String(describing: ValidateServiceProtocol.self):
            return ValidateService() as? T
        case String(describing: UpdateServiceProtocol.self):
            return UpdateService() as? T
        case String(describing: SendMessageProtocol.self):
            return SendMessageService() as? T
        case String(describing: ChatServiceProtocol.self):
            return ChatService() as? T
        default:
            return nil
        }
    }
}
