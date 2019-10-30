//
//  UILabel+Extension.swift
//  Remises-RC
//
//  Created by juan ledesma on 1/25/19.
//  Copyright © 2019 umbraApps. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func makeLoadingAnimation(text: String, stop: Bool) {
        var timer: Timer?
        
        if stop {
            //Stop the timer
            timer?.invalidate()
        } else {
            
            self.text = "\(text) ."
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.55, repeats: true) { (timer) in
                var string: String {
                    switch self.text {
                    case "\(text) .":       return "\(text) .."
                    case "\(text) ..":      return "\(text) ..."
                    case "\(text) ...":     return "\(text) ."
                    default:                return "\(text)"
                    }
                }
                self.text = string
                
            }
        }
    }
    
}
