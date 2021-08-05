//
//  MessageViewModel.swift
//  DARDESH
//
//  Created by Mohamed Ali on 27/07/2021.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import MessageKit

class MessageViewModel {
    
    // MARK:- TODO:- Initialise new rx varible here.
    var inputTextFieldBahaviour = BehaviorRelay<String>(value: "")
    
    var ChatIdBahaviour = BehaviorRelay<String>(value: "")
    var recipientidBahaviour = BehaviorRelay<String>(value: "")
    var recipientNameBahaviour = BehaviorRelay<String>(value: "")
    
    var responseBehaviour = BehaviorRelay<Bool>(value: false)
    
    var MessagesBahaviour = BehaviorRelay<[MKMessage]>(value: [])
    
    private var allLocalMessageBehaviour = ReplaySubject<Results<MessageModel>>.createUnbounded()
    private var allLocalMessageObservable: Observable<Results<MessageModel>> {
        return allLocalMessageBehaviour
    }
    
    let realm = try! Realm()
    var notificationToken: NotificationToken?
    let disposebag = DisposeBag()
    // ------------------------------------------------
    
    // MARK:- TODO:- Add Condtions here to rx swift.
    var isinputTextFieldEmpty: Observable<Bool> {
        
        return inputTextFieldBahaviour.asObservable().map { input -> Bool in
            let isInputhEmpty = input.trimmingCharacters(in: .whitespaces).isEmpty
            
            return isInputhEmpty
        }
        
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method for Getten Current User Data from UserDefaults
    func GetCurrentUserData() -> UserModel {
        return UserDefaultsMethods.loadDataFromUserDefaults(Key: currentUser, className: UserModel.self)!
    }
    // ------------------------------------------------
    
    
    
    // MARK:- TODO:- Send Messgae Function.
    func sendMessageTextOperation() {
        
        let senderId = GetCurrentUserData().uid
        
        Outgoing.shared.sendMessage(chatid: ChatIdBahaviour.value, text: inputTextFieldBahaviour.value, photo: nil, video: nil, audio: nil, audioDuration: 0.0, memberIds: [senderId , recipientidBahaviour.value], location: nil)
    }
    // ------------------------------------------------
    
    
    
    // MARK:- TODO:- LoadMessage From Realm database and put it into messageCollectionView.
    func loadMessageOperation(messageViewContrller: MessageViewController) {
        
        // Get Messages from Realm database.
        let predicate = NSPredicate(format: "chatRoomId = %@", ChatIdBahaviour.value)
        
        let messages = realm.objects(MessageModel.self).filter(predicate).sorted(byKeyPath: "date", ascending: true)
        
        if messages.isEmpty {
            GetOldMessages()
        }
        
        allLocalMessageBehaviour.onNext(messages)
        allLocalMessageBehaviour.onCompleted()
        
        // Add Listener to Realm swift and load messages from it to mkmessages.
        notificationToken = messages.observe({ [weak self] (change: RealmCollectionChange) in
            
            guard let self = self else { return }
            
            switch change {
                
            case .initial:
                self.insertAllMessages(messageViewContrller: messageViewContrller)
                self.responseBehaviour.accept(true)
                
            case .update:
                self.insertAllMessages(messageViewContrller: messageViewContrller)
                self.responseBehaviour.accept(true)
                
            case .error(let error):
                print("Error on new insertion \(error.localizedDescription)")
            }
        })
        
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method Reading New messages from firebase and add it on Realm Database.
    func ReadNewMessagesOpertation() {
        
        let userid = GetCurrentUserData().uid
        
        FirebaseLayer.RealtimeReadNewMessages(collectionId: ChatIdBahaviour.value, documntId: userid, LastMessageDate: LastMessageDate()) { query, error in
            
            if error != nil {
                print("Error in Getting Messages")
            }
            else {
                
                guard let query = query else {
                    print("No Messages Found in database")
                    return
                }
                
                for i in query.documentChanges {
                    
                    if i.type == .added {
                        
                        let reasult = Result {
                            try? i.document.data(as: MessageModel.self)
                        }
                        
                        switch reasult {
                        
                        case .success(let mess):
                            
                            if let mess = mess {
                                if mess.Senderid != userid {
                                    RealmswiftLayer.Save(mess)
                                }
                            }
                            
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                        
                    }
                    
                }
            }
            
        }
    }
    // ------------------------------------------------
    
    
    
    // MARK:- TODO:- This Medthod For Getten Message from Firebase.
    private func GetOldMessages() {
        
        let userId = GetCurrentUserData().uid
        
        FirebaseLayer.ReadOldMessages(collectionId: ChatIdBahaviour.value , documntId: userId) { query, error in
            
            if error != nil {
                print("Error in Getting Messages")
            }
            else {
                
                guard let query = query?.documents else {
                    print("No Messages Found in database")
                    return
                }
                
                var oldmessages = query.compactMap { (querysanpshot) -> MessageModel? in
                    return try? querysanpshot.data(as: MessageModel.self)
                }
                
                oldmessages.sort(by: {$0.date < $1.date})
                
                for message in oldmessages {
                    RealmswiftLayer.Save(message)
                }
                
            }
            
        }
        
    }
    // ------------------------------------------------
    
    
    
    
    // MARK:- TODO:- This Method For Insert All To Mkmessages Behaviour.
    private func insertAllMessages(messageViewContrller: MessageViewController) {
        
        allLocalMessageObservable.asObservable().subscribe(onNext: {  [weak self] result in
            
            guard let self = self else { return }
            
            print("Messages Found: \(result.count)")
            
            var mkmessages = Array<MKMessage>()
            
            let incomming = Incomming(messageViewController: messageViewContrller)
            
            for i in result {
                
                let mkmessage = incomming.createMCMessage(localMessage: i)
                mkmessages.append(mkmessage)
            }
            
            self.MessagesBahaviour.accept(mkmessages)
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method Help To Get Last Current Date From Realm Database.
    private func LastMessageDate() -> Date {
        
        var lastmessage: Date?
        
        allLocalMessageBehaviour.subscribe(onNext: { messages in
            
            lastmessage = messages.last?.date ?? Date()
            
        }).disposed(by: disposebag)
        
        return Calendar.current.date(byAdding: .second, value: 1, to: lastmessage!) ?? lastmessage!
    }
    // ------------------------------------------------
    
}