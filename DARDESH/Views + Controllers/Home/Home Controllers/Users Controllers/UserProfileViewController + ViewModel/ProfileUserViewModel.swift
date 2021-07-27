//
//  ProfileUserViewModel.swift
//  DARDESH
//
//  Created by Mohamed Ali on 10/07/2021.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileUserViewModel {
    
    // MARK:- TODO:- Intialize new rxvarible Here:-
    var ResponseData = BehaviorRelay<String>(value: "")
    var chatRoomid = BehaviorRelay<String>(value: "")
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Creating Room Chat When tapped on Start Chat Button.
    func StartChat (sender: UserModel , Receiver: UserModel) {
        
        var chatRoomId = ""
        
        let res = sender.uid.compare(Receiver.uid).rawValue
        
        if res < 0 {
            chatRoomId = sender.uid + Receiver.uid
        }
        else {
            chatRoomId = Receiver.uid + sender.uid
        }
        
        self.chatRoomid.accept(chatRoomId)
        
        CreateChatRooms(chatRoomId: chatRoomId, Users: [sender,Receiver])
        
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- Get Sender User Data
    func GetUserData() -> UserModel? {
        
        return UserDefaultsMethods.loadDataFromUserDefaults(Key: currentUser, className: UserModel.self)
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Check if Chat Room exsist for one or two persones deleted or not.
    private func CreateChatRooms(chatRoomId: String, Users: [UserModel]) {
        
        // Check Not Creating Doublicated Chat To Same Users.
        var usersToCreateString = Array<String>()
        
        for user in Users {
            usersToCreateString.append(user.uid)
        }
        
        FirebaseLayer.publicreadWithWhereCondtion(collectionName: chatCollection, key: RoomId, value: chatRoomId) { [weak self] snapshot in
            
            guard let self = self else { return }
            
            guard let snapshot = snapshot else {
                print("No Element")
                return
            }
            
            if !snapshot.isEmpty {
                
                let data = snapshot.documents.compactMap { (snapshot) -> ChatModel? in
                    return try? snapshot.data(as: ChatModel.self)
                }
                
                for i in data {
                    if usersToCreateString.contains(i.senderID) {
                        
                        usersToCreateString.remove(at: usersToCreateString.firstIndex(of: i.senderID)!)
                        
                    }
                }
            }
            else {
                
                // Create ChatRoom With Sender -> Receiver
                for u in usersToCreateString {
                    
                    let senderUser = u == userID ? self.GetSender(users: Users) : self.GetReceiver(users: Users)
                    
                    let receiverUser = u == userID ? self.GetReceiver(users: Users) : self.GetSender(users: Users)
                    
                    let ob = ChatModel(id: UUID().uuidString
                                       , chatRoomId: chatRoomId
                                       , senderID: senderUser.uid
                                       , senderName: senderUser.UserName
                                       , RecevierID: receiverUser.uid
                                       , RecevierName: receiverUser.UserName
                                       , date: Date()
                                       , membersId: [senderUser.uid,receiverUser.uid]
                                       , lastMessage: ""
                                       , unreadCounter: 0
                                       , AvatarLink: receiverUser.Image)
                    
                    
                    // Save To Firestore
                    self.SaveToFirestore(ob: ob)
                    
                }
                
            }
            
            
        }
        
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- Get Receiver Data From Array.
    private func GetReceiver (users: [UserModel]) -> UserModel {
        
        var ReceverUser: UserModel?
        
        for i in users {
            if i.uid == userID {
                continue
            }
            else {
                ReceverUser = i
                break
            }
        }
        
        return ReceverUser!
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- Get Sender Data From Array.
    private func GetSender (users: [UserModel]) -> UserModel {
        
        var SenderUser: UserModel?
        
        for i in users {
            if i.uid == userID {
                SenderUser = i
                break
            }
        }
        
        return SenderUser!
    }
    // ------------------------------------------------
    
    
    
    // MARK:- TODO:- Save Data to Chat Firestore Collection.
    private func SaveToFirestore(ob: ChatModel) {
        
        do {
            
            try FirebaseLayer.refernceCollection(chatCollection).document(ob.id).setData(from: ob) {
                [weak self] error in
                
                guard let self = self else {return}
                
                if error != nil {
                    self.ResponseData.accept("Failed")
                    
                }
                else {
                    self.ResponseData.accept("Success")
                }
                
            }
            
        }
        catch {
            print("Error in converting \(error.localizedDescription)")
        }
        
    }
    // ------------------------------------------------
    
}
