//
//  Outgoing.swift
//  DARDESH
//
//  Created by Mohamed Ali on 28/07/2021.
//

import UIKit
import FirebaseFirestoreSwift
import Gallery


class Outgoing {
    
    let messageviewmodel = MessageViewModel()
    
    // MARK:- TODO:- Send Messgae Function.
    func sendMessage(chatid: String,text: String?, photo: UIImage? , video: Video?, audio: String?, audioDuration: Float = 0.0, memberIds: [String],location: String?){
        
        let senderUser = messageviewmodel.GetCurrentUserData()
        
        // 1. Create local message from the data we have
        let message = MessageModel()
        message.id = UUID().uuidString
        message.chatRoomId = chatid
        message.Senderid = senderUser.uid
        message.SenderName = senderUser.UserName
        message.Senderinitials = String(senderUser.UserName.first!)
        message.date = Date()
        message.status = sentstatus
        
        
        // 2.check message type
        if let text = text {
            message.message = text
            message.type = textType
        }
        
        if photo != nil {
            
        }
        
        if video != nil {
            
        }
        
        if location != nil {
            
        }
        
        if audio != nil {
            
        }
        
        
        // 3. save message locally
        RealmswiftLayer.Save(message)
        
        // 4. save message to firestore
        for memberid in memberIds {
            
            FirebaseLayer.WriteMessageToFirebase(message: message, MemberId: memberid)
        }
        
        // 5. Send Push notification
        
        // 6. Update Chat Room
        
    }
    // ------------------------------------------------
    
}
