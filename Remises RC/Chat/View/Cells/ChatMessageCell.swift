//
//  ChatMessageCell.swift
//  Remises-RC
//
//  Created by juan ledesma on 1/31/19.
//  Copyright © 2019 umbraApps. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    
    let labelTitle: UILabel = {
        let tx = UILabel()
//        tx.text = "Jugador"
        tx.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        tx.translatesAutoresizingMaskIntoConstraints = false
        tx.backgroundColor = UIColor.clear
        tx.textColor = .white
        return tx
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
//        tv.text = "SAMPLE TEXT FOR NOW"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = .black
        tv.isEditable = false
        return tv
    }()
    
    static let grayBubbleImage = UIImage(named: "bubble_gray")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 20)).withRenderingMode(.alwaysTemplate)
    static let blueBubbleImage = UIImage(named: "bubble_blue")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 20, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(textView)
//        addSubview(labelTitle)
        
        //x,y,w,h
        
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20)
        bubbleViewRightAnchor?.isActive = true
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20)
        //        bubbleViewLeftAnchor?.active = false
        
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //ios 9 constraints
        //x,y,w,h
        
        
//        labelTitle.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 16).isActive = true
//        labelTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
//        labelTitle.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -16).isActive = true
//        labelTitle.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 22).isActive = true
        textView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 0).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -22).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        
        
        
        //        bubbleView.addConstraintsWithFormat("H:|[v0]|", views: bubbleImageView)
        //        bubbleView.addConstraintsWithFormat("V:|[v0]|", views: bubbleImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

