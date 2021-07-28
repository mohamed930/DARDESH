//
//  MessgaeModel.swift
//  DARDESH
//
//  Created by Mohamed Ali on 27/07/2021.
//

import Foundation
import RealmSwift

class MessageModel: Object, Codable {
    
    @objc dynamic var id: String = ""
    @objc dynamic var chatRoomId: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var SenderName: String = ""
    @objc dynamic var Senderid: String = ""
    @objc dynamic var Senderinitials: String = ""
    @objc dynamic var readDate: Date = Date()
    @objc dynamic var type: String = ""
    @objc dynamic var status: String = ""
    @objc dynamic var message: String = ""
    @objc dynamic var audioUrl: String = ""
    @objc dynamic var videoUrl: String = ""
    @objc dynamic var imageUrl: String = ""
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longtitude: Double = 0.0
    @objc dynamic var audioDuration: Double = 0.0
    
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
