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
    
    public static let shared = Outgoing()
    
    private let messageviewmodel = MessageViewModel()
    
    // MARK:- TODO:- Send Messgae Function.
    func sendMessage(chatid: String,text: String?, photo: UIImage? , video: Video?, audio: String?, audioDuration: Float = 0.0, memberIds: [String],location: String?){
        
        let senderUser = messageviewmodel.GetCurrentUserData()
        
        // 1. Create local message from the data we have
        let message = MessageModel()
        message.id = UUID().uuidString
        message.chatRoomId = chatid
        message.Senderid = senderUser.uid
        message.SenderName = senderUser.UserName
        message.Senderinitials = String(senderUser.UserName.first!).capitalized
        message.date = Date()
        message.status = sentstatus
        
        
        // 2.check message type
        if let text = text {
            SendText(message: message , Text: text, memberIds: memberIds)
        }
        
        if photo != nil {
            SendImage(message: message, Image: photo!, memberIds: memberIds)
        }
        
        if video != nil {
            
        }
        
        if location != nil {
            
        }
        
        if audio != nil {
            
        }
        
        
        // 5. Send Push notification
        
        // 6. Update Chat Room
        messageviewmodel.UpdateChatRoomsOperation(chatRoomId: chatid, lastMess: message.message)
        
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Save Images into Firebase and RealmSwift.
    private func SaveMessages (message: MessageModel , membersIds: [String]) {
        
        // 3. save message locally
        self.messageviewmodel.responseReadedBehaviour.accept(false)
        RealmswiftLayer.Save(message)
        
        // 4. save message to firestore
        for memberid in membersIds {
            
            FirebaseLayer.WriteMessageToFirebase(message: message, MemberId: memberid)
        }
        
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Sending Text to Firebase & Realm database.
    private func SendText (message: MessageModel ,Text: String , memberIds: [String]) {
        
        message.message = Text
        message.type = textType
        
        SaveMessages(message: message, membersIds: memberIds)
        
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Sending Image to Firebase & Realm database.
    private func SendImage(message: MessageModel ,Image: UIImage , memberIds: [String]) {
        
        message.message = "Photo Message"
        message.type = imageType
        
        // initialise image name and directory
        let id = UUID().uuidString
        let fileName = Date().StringDate() + id
        let fileDirectory = "MediaMessages/Photo/" + "\(message.chatRoomId)" + "_ \(fileName)" + ".jpg"
        
        // Save Image Locally.
        FileManagerLayer.shared.SaveFileLocally(fileData: Image.jpegData(compressionQuality: 0.6)! as NSData, fileName: fileName)
        
        // Upload Image to storage and add to message and save into messages collection.
        FirebaseLayer.uploadMedia(ImageFolder: fileDirectory, PickedImage: Image) { [weak self] url in
            
            guard let self = self else { return }
            
            guard let url = url else { return }
            
            message.imageUrl = url
            
            // Save message to message collection.
            self.SaveMessages(message: message, membersIds: memberIds)
            
        }
        
    }
    // ------------------------------------------------
}
