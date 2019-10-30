//
//  ChatViewController.swift
//  Remises-RC
//
//  Created by juan ledesma on 1/31/19.
//  Copyright © 2019 umbraApps. All rights reserved.
//

import UIKit
import PullUpController
import SkyFloatingLabelTextField

protocol ChatMessageDelegate {
    func chatMessageReceivedDelegate(msg : String?)
}

class ChatViewController: PullUpController {
    
    @IBOutlet weak var txtChat: SkyFloatingLabelTextField!
    var initialPointOffset: CGFloat {
        return 60
    }
    
    public var portraitSize: CGSize = .zero
    public var landscapeFrame: CGRect = .zero

    @IBOutlet weak var collectionView: UICollectionView!
    let cellId = "cellId"
    
    var messages: [String] = []
    var isDriver: [Bool] = []
    
    var delegate : ChatMessageDelegate?
    var viewModel: ChatViewViewModelDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtChat.delegate = self
        self.delegate = self

        self.setupKeyboardObservers()
        self.setCollectionsConfig()
        portraitSize = CGSize(width: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height),
                              height: (UIScreen.main.bounds.height/2))
        

        // Do any additional setup after loading the view.
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
        guard let input = input else { return nil }
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
        return input.rawValue
    }

    
    private func setCollectionsConfig() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 40, right: 0)
        self.collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    @objc func handleKeyboardDidShow() {
        if self.messages.count > 0 {
            let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
    
    @IBAction func btnChatPressed(_ sender: UIButton) {
        self.viewModel?.sendMessage(message: self.txtChat.text ?? "")
        self.view.endEditing(true)
        let msg = self.txtChat.text
        if self.txtChat.text != "" {
            self.onNewMessage(data: msg)
            self.txtChat.text = ""
        }
    }
    
    func newChat(data: NSDictionary?) {
        print(data)
        DispatchQueue.main.async(execute: {
            self.collectionView.reloadData()
            self.handleKeyboardDidShow()
        })
    }
    
    func onNewMessagedriver(data:String?) {
        self.isDriver.append(true)
        self.messages.append(data ?? "")
        DispatchQueue.main.async(execute: {
            self.collectionView?.reloadData()
            self.handleKeyboardDidShow()
        })
    }
    
    private func onNewMessage(data: String?) {
        self.isDriver.append(false)
        self.messages.append(data ?? "")
        DispatchQueue.main.async(execute: {
            self.collectionView?.reloadData()
            self.handleKeyboardDidShow()
        })
        
        
    }

    fileprivate func setupCell(_ cell: ChatMessageCell, fromUser: Bool) {
        
        if fromUser {
            cell.textView.textColor = UIColor.black
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            cell.labelTitle.textAlignment = .left
            cell.textView.textAlignment = .left
            cell.textView.isScrollEnabled = false
            
        } else {
            cell.textView.textColor = UIColor.black
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            cell.labelTitle.textAlignment = .right
            cell.textView.textAlignment = .right
            cell.textView.isScrollEnabled = false
            
        }
    }
    
    fileprivate func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 250, height: 1020)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.systemFont(ofSize: 16)]), context: nil)
    }



    
    override func pullUpControllerWillMove(to stickyPoint: CGFloat) {
        //        print("will move to \(stickyPoint)")
    }
    
    override func pullUpControllerDidMove(to stickyPoint: CGFloat) {
        //        print("did move to \(stickyPoint)")
    }
    
    override func pullUpControllerDidDrag(to point: CGFloat) {
        //        print("did drag to \(point)")
    }
    
    // MARK: - PullUpController
    
    override var pullUpControllerPreferredSize: CGSize {
        return portraitSize
    }
    
    override var pullUpControllerPreferredLandscapeFrame: CGRect {
        return landscapeFrame
    }
    
//    override var pullUpControllerMiddleStickyPoints: [CGFloat] {
//        switch initialState {
//        case .contracted:
//            return [firstPreviewView.frame.maxY]
//        case .expanded:
//            return [searchBoxContainerView.frame.maxY, firstPreviewView.frame.maxY]
//        }
//    }
    
    override var pullUpControllerBounceOffset: CGFloat {
        return 30
    }
    
    override func pullUpControllerAnimate(action: PullUpController.Action,
                                          withDuration duration: TimeInterval,
                                          animations: @escaping () -> Void,
                                          completion: ((Bool) -> Void)?) {
        switch action {
        case .move:
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: animations,
                           completion: completion)
        default:
            UIView.animate(withDuration: 0.3,
                           animations: animations,
                           completion: completion)
        }
    }



}

extension ChatViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        let index = indexPath.row
        
        let message = self.messages[index]
        cell.textView.text = message
        
        setupCell(cell, fromUser: self.isDriver[index])
        
        //lets modify the bubbleView's width somehow???
        
        let messageWidth = estimateFrameForText(message).width + 70
        
        cell.bubbleWidthAnchor?.constant = messageWidth
        
        
        if let bubbleImage = cell.viewWithTag(997) as? UIImageView {
            bubbleImage.removeFromSuperview()
        }
        
        let bubbleImageView: UIImageView = {
            let imageView = UIImageView()
            if  self.isDriver[index] {
                imageView.image = ChatMessageCell.grayBubbleImage
//                cell.labelTitle.text = "CRE"
                imageView.tintColor = Colors.chatGray
            } else {
                imageView.image = ChatMessageCell.blueBubbleImage
//                cell.labelTitle.text = "Jugador"
                imageView.tintColor = Colors.chatGreen.withAlphaComponent(0.3)
            }

            imageView.frame = CGRect(x: 0, y: 0, width: (cell.bubbleWidthAnchor?.constant ?? 0), height: estimateFrameForText(self.messages[indexPath.item]).height + 15)
            imageView.tag = 997
            return imageView
        }()
        
        cell.bubbleView.addSubview(bubbleImageView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 100
        
        //get estimated height somehow????
        if messages[indexPath.item] != ""  {
            height = estimateFrameForText(messages[indexPath.item]).height + 15
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    
}

extension ChatViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text != "" {
            return true
        } else {
            return false
        }
    }
}

extension ChatViewController: ChatMessageDelegate {
    func chatMessageReceivedDelegate(msg: String?) {
        
    }
    
    
}


extension ChatViewController: ChatViewViewModelView {
    func showChat() {
        let message: [String: Any] = ["message": ""]
        NotificationCenter.default.post(name: .showChatViewController, object: nil, userInfo: message)
    }
    
    //Cannot inherit from baseViewController
    func showLoader() {

    }
    
    func hideLoader() {

    }
    
    func showAlert(title: String, message: String) {

    }
    
    func popViewController() {

    }
    
    func showUpdatedMessage() {
        
    }
    
}

