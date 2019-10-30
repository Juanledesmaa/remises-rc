//
//  GetDataNotification.swift
//  Remises-RC
//
//  Created by juan ledesma on 1/31/19.
//  Copyright © 2019 umbraApps. All rights reserved.
//

import Foundation

func getDataAsignacion(userInfo: NSDictionary?) -> Asignacion? {
    if let notificationData = userInfo?["datos"] as? NSString {
        
        var dictionary:NSDictionary?
        if let data = notificationData.data(using: String.Encoding.utf8.rawValue) {
            do {
                dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                
                if let alertDictionary = dictionary {

                    do {
                        let movil = alertDictionary["movil"] as? [String: Any]
                        print(movil)
                        print("AQUI")
                        let data = jsonToNSData(json: movil as AnyObject)
                        let movilDatos = try JSONDecoder().decode(Asignacion.self, from: data as Data? ?? Data())

                        return movilDatos
                        
                    } catch let parseError as NSError {
                        return nil
                    }
                    
                }
            } catch{
                return nil
            }
        }
    }
    
    return nil
}

func getComandoNotification(userInfo: NSDictionary?) -> String? {
    if let notificationData = userInfo?["datos"] as? NSString {
        
        var dictionary:NSDictionary?
        if let data = notificationData.data(using: String.Encoding.utf8.rawValue) {
            do {
                dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                
                if let alertDictionary = dictionary {
                        let comando = alertDictionary["comando"] as? String
                        return comando
                } else {
                    return nil
                }
            } catch{
                return nil
            }
        }
    }
    
    return nil
}

func getDataChat(userInfo: NSDictionary?) -> String? {
    if let notificationData = userInfo?["datos"] as? NSString {
        
        var dictionary:NSDictionary?
        if let data = notificationData.data(using: String.Encoding.utf8.rawValue) {
            do {
                dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                
                if let alertDictionary = dictionary {
                    let mensaje = alertDictionary["mensaje"] as? String
                    return mensaje
                } else {
                    return nil
                }
            } catch{
                return nil
            }
        }
    }
    
    return nil
}

