//
//  MessagesDisplayDelegate.swift
//  DARDESH
//
//  Created by Mohamed Ali on 30/07/2021.
//

import Foundation
import MessageKit

extension MessageViewController: MessagesDisplayDelegate {
    
    // MARK:- TODO:- this method for change message text color.
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            // Fallback on earlier versions
            return .black
        }
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- this method for change message background
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        let bubbleColor = UIColor(named: "Color 4")
        let bublbeColorIncommig = UIColor(named: "Color 3")
        
        return isFromCurrentSender(message: message) ? bubbleColor! : bublbeColorIncommig!
        
    }
    // ------------------------------------------------
    
    
    
    // MARK:- TODO:- This message to add shape at the end of message body for sender and recever and control direction.
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        
        return .bubbleTail(tail, .curved)
        
    }
    // ------------------------------------------------
    
}
