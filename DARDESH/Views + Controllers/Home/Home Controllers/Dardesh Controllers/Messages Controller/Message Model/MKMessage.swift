//
//  MKMessage.swift
//  DARDESH
//
//  Created by Mohamed Ali on 28/07/2021.
//

import Foundation
import MessageKit

class MKMessage: NSObject, MessageType {
    
    var messageId: String = ""
    var kind: MessageKind
    var sentDate: Date
    var mksender: MKSender
    var sender: SenderType {return mksender}
    var senderinitials: String
    
    var status: String
    var readData: Date
    var incomming: Bool
    
    init(message: MessageModel) {
        self.messageId = message.id
        self.mksender = MKSender(senderId: message.Senderid, displayName: message.SenderName)
        self.status = message.status
        self.kind = MessageKind.text(message.message)
        self.senderinitials = message.Senderinitials
        self.sentDate = message.date
        self.readData = message.readDate
        self.incomming = userID != mksender.senderId
    }
    
    
    
    
}
