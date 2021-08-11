//
//  messagesLayoutDelegate.swift
//  DARDESH
//
//  Created by Mohamed Ali on 30/07/2021.
//

import Foundation
import MessageKit

extension MessageViewController: MessagesLayoutDelegate {
    
    // MARK:- TODO:- this method for control cellTopLabelHeight
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        if indexPath.section % 3 == 0{
            
            if indexPath.section == 0 && messageviewmodel.alllocalMessgaes > messageviewmodel.displayNumber {
                return 40.0
            }
            
        }
        
        return 15.0
        
    }
    // ------------------------------------------------
    
    
    
    // MARK:- TODO:- this method for control cellBottomLabelHeight
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return isFromCurrentSender(message: message) ? 17.0 : 0.0
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- this method for control messageBottomLabelHeight
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        let lmessage = self.messageviewmodel.MessagesBahaviour.value
        
        return indexPath.section != lmessage.count - 1 ? 15.0: 0.0
        
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- this method for control configureAvatarView
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        let lmessage = self.messageviewmodel.MessagesBahaviour.value
        
        avatarView.set(avatar: Avatar(initials: lmessage[indexPath.section].senderinitials))
    }
    // ------------------------------------------------
}
