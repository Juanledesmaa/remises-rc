//
//  ChatViewModel.swift
//  Remises-RC
//
//  Created by juan ledesma on 1/31/19.
//  Copyright © 2019 umbraApps. All rights reserved.
//

import Foundation

protocol ChatViewViewModelView: BaseViewModel {
    func showUpdatedMessage()
    func showChat()
}

protocol ChatViewViewModelDelegate {
    func sendMessage(message: String)
    func loadChat()
}

class ChatViewModel: ChatViewViewModelDelegate {
    weak var view: ChatViewViewModelView?
    var service: SendMessageProtocol?
    var chatService: ChatServiceProtocol?
    
    init(view: ChatViewViewModelView?, service: SendMessageProtocol?, chatService: ChatServiceProtocol?) {
        self.view = view
        self.service = service
        self.chatService = chatService
    }
    
    func sendMessage(message: String) {
        service?.sendMessage(message: message, completion: {
            (response, error) in
            if error != nil {
                print("HA OCURRIDO UN ERROR")
            } else {
                self.view?.showUpdatedMessage()
            }
        })
    }
    
    func loadChat() {
        chatService?.loadChat(completion: {
            (response, error) in
            if error != nil {
                print("HA OCURRIDO UN ERROR")
            } else {
                if response {
                    self.view?.showChat()
                }
            }
        })
        
    }
}
