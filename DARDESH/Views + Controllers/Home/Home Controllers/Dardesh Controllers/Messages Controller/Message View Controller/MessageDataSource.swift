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
    
    
    // MARK:- TODO:- This Method For Cell Attributed To Show Date For 3 Messages and if it first index show pull to more.
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        // To Set Show More is true or not.
        let showloadMore = (indexPath.section == 0 && (messageviewmodel.alllocalMessgaes > messageviewmodel.displayNumber))
        
        let text = showloadMore == true ? "MoreLoad".localized : MessageKitDateFormatter.shared.string(from: message.sentDate)
        
        let font = showloadMore ? UIFont.systemFont(ofSize: 13) : UIFont.boldSystemFont(ofSize: 10)
        
        let color = showloadMore ? UIColor.systemBlue : UIColor.darkGray
        
        if indexPath.section % 3 == 0 {
            
            return NSAttributedString(string: text, attributes: [.font: font , .foregroundColor: color])
        }
        
        return nil
        
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Last message Show status and sent date.
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        if isFromCurrentSender(message: message) {
            let message = self.messageviewmodel.MessagesBahaviour.value
            let lmessage = message[indexPath.section]
            
            let status = indexPath.section == self.messageviewmodel.MessagesBahaviour.value.count - 1 ? lmessage.status + " " + lmessage.readData.ConvertTimeString() : ""
            
            let font = UIFont.boldSystemFont(ofSize: 10)
            let color = UIColor.darkGray
            
            return NSAttributedString(string: status, attributes: [.font: font, .foregroundColor: color])
        }
        
        return nil
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For add date to all messages withoud last message date.
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        let lmessage = self.messageviewmodel.MessagesBahaviour.value
        
        if indexPath.section != lmessage.count - 1 {
            
            let font = UIFont.boldSystemFont(ofSize: 10)
            let color = UIColor.darkGray
            
            return NSAttributedString(string: message.sentDate.ConvertTimeString(), attributes: [.font: font,.foregroundColor: color])
            
        }
        
        return nil
    }
    // ------------------------------------------------
    
}
