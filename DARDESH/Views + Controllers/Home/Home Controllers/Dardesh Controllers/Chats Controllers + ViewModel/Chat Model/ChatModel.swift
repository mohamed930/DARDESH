//
//  ChatModel.swift
//  DARDESH
//
//  Created by Mohamed Ali on 19/07/2021.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatModel: Codable {
    var id: String
    var chatRoomId: String
    
    var senderID: String
    var senderName: String
    
    var RecevierID: String
    var RecevierName: String
    
    @ServerTimestamp var date = Date()
    
    var membersId = [""]
    
    var lastMessage: String
    var unreadCounter = 0
    
    var AvatarLink: String
}
