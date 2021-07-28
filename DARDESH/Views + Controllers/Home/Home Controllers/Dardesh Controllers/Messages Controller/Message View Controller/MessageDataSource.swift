//
//  MessageDataSource.swift
//  DARDESH
//
//  Created by Mohamed Ali on 28/07/2021.
//

import Foundation
import MessageKit

extension MessageViewController: MessagesDataSource {
    
    func currentSender() -> SenderType {
        return currentUserSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        let data = messageviewmodel.MessagesBahaviour.value
        return data[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageviewmodel.MessagesBahaviour.value.count
    }
    
    
}
