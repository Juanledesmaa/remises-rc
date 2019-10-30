//
//  LoadingView.swift
//  Remises-RC
//
//  Created by juan ledesma on 1/25/19.
//  Copyright © 2019 umbraApps. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

extension UIView {
    func startLoading(text: String) {
        let frame = self.frame
        let centerY = (frame.height / 3.5)
        let centerX = (frame.width / 2)
        let activity = NVActivityIndicatorView(frame: CGRect(x: centerX - 30, y: centerY - 30, width: 60, height: 60), type: NVActivityIndicatorType.circleStrokeSpin, color: Colors.mainBlue, padding: 0)
        
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 240, height: 70))
        label.tag = 989
        label.center = CGPoint(x: centerX, y: centerY + 70)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.numberOfLines = 0
        //        label.text = "En un minuto recibira un SMS de confirmación"
        label.text = text
        self.addSubview(label)
        activity.tag = 979
        self.isUserInteractionEnabled = false
        self.addSubview(activity)
        activity.startAnimating()
    }
    
    func stopLoading() {
        if let viewWithTag = self.viewWithTag(979) {
            viewWithTag.removeFromSuperview()
            self.isUserInteractionEnabled = true
        } else {
            
        }
        
        if let viewWithTag = self.viewWithTag(989) {
            viewWithTag.removeFromSuperview()
            self.isUserInteractionEnabled = true
        } else {
            
        }
    }
}
