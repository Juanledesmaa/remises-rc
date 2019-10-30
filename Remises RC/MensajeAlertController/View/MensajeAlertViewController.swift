//
//  MensajeAlertViewController.swift
//  Remises-RC
//
//  Created by juan ledesma on 1/31/19.
//  Copyright © 2019 umbraApps. All rights reserved.
//

import UIKit

protocol MensajeDelegate {
    func btnCerrarPressedDelegate()
}

class MensajeAlertViewController: UIViewController {

    @IBOutlet weak var lblMensaje: UILabel!
    @IBOutlet weak var viewMain: UIView!
    var delegate: MensajeDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        self.viewMain.layer.cornerRadius = 15
    }
    
    @IBAction func btnCerrarPressed(_ sender: UIButton) {
        self.removeAnimate()
        if let _ = delegate {
            delegate?.btnCerrarPressedDelegate()
        }
        
    }
    
    private func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.viewMain.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.viewMain.alpha = 1.0
            self.viewMain.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.3, animations: {
            self.viewMain.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.viewMain.alpha = 0.0
        }, completion:{(finished : Bool)  in
            if (finished) {
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
        })
    }
}
