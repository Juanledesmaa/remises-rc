//
//  JSONToNSData.swift
//  Remises-RC
//
//  Created by juan ledesma on 1/31/19.
//  Copyright © 2019 umbraApps. All rights reserved.
//

import Foundation

func jsonToNSData(json: AnyObject) -> NSData?{
    do {
        return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
    } catch let myJSONError {
        print(myJSONError)
    }
    return nil;
}
