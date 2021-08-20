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
    
    var isTypingBehaviour = BehaviorRelay<Bool>(value: false)
    
    var MessagesBahaviour = BehaviorRelay<[MKMessage]>(value: [])
    
    private var allLocalMessageBehaviour = ReplaySubject<Results<MessageModel>>.createUnbounded()
    private var allLocalMessageObservable: Observable<Results<MessageModel>> {
        return allLocalMessageBehaviour
    }
    
    let realm = try! Realm()
    var notificationToken: NotificationToken?
    let disposebag = DisposeBag()
    
    var max = 0
    var mini = 0
    var displayNumber = 0
    var alllocalMessgaes = 0
    
    var typingCount = 0
    
    let numberOfShowMessgaes = 12
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
                self.insertMessages(messageViewContrller: messageViewContrller)
                self.responseBehaviour.accept(true)
                
            case .update:
                self.insertOneMessages(messageViewContrller: messageViewContrller)
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
    
    
    
    // MARK:- TODO:- This Method For Insert 12 More Messages To Mkmessages Behaviour.
    func insertMoreMessagesOperation(messageViewContrller: MessageViewController) {
        
        allLocalMessageObservable.asObservable().subscribe(onNext: {  [weak self] result in
            
            guard let self = self else { return }
            
            var mkmessages = self.MessagesBahaviour.value
            let incomming = Incomming(messageViewController: messageViewContrller)
            
            self.max = self.mini - 1
            self.mini = self.max - self.numberOfShowMessgaes
            
            if self.mini < 0 {
                self.mini = 0
            }
            
            // Add Some Messages from first load.
            for i in (self.mini ... self.max).reversed() {
                let mkmessage = incomming.createMCMessage(localMessage: result[i])
                mkmessages.insert(mkmessage, at: 0)
                self.displayNumber += 1
            }
            
            self.MessagesBahaviour.accept(mkmessages)
            self.alllocalMessgaes = result.count
            
            
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- CheckIsTyping From Firebase Operation.
    func startTypingIdecatorOperation() {
        
        typingCount += 1
        isTypingCounter(type: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.typingCount -= 1
            
            if self.typingCount == 0 {
                self.isTypingCounter(type: false)
            }
            
        }
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Check Typing Lestner From Firebase.
    func isTypingLestner() {
        
        let currentUserId = GetCurrentUserData().uid
        
        FirebaseLayer.RealtimeReadisTyping(ChatRoomId: ChatIdBahaviour.value) { snapshot, error in
            
            if error != nil {
                self.isTypingBehaviour.accept(false)
                print("Error in reading")
            }
            else {
                
                for data in snapshot.data()! {
                    if data.key != currentUserId {
                        self.isTypingBehaviour.accept(data.value as! Bool)
                    }
                }
                
            }
        }
        
    }
    // ------------------------------------------------
    
    
    
    // MARK:- TODO:- This Method For Check Typing Lestner From Firebase.
    func ReomoveAllLestnerOperation() {
        FirebaseLayer.isTypingListner.remove()
        FirebaseLayer.newmessagesListner.remove()
    }
    // ------------------------------------------------
    

    
    // MARK:- TODO:- This Method For UpdateCounter in chatRoom with Id.
    func UpdateCounterUsingIdOperatoin() {
        
        let senderId = self.GetCurrentUserData().uid
        
        FirebaseLayer.refernceCollection(chatCollection).whereField(RoomId, isEqualTo: ChatIdBahaviour.value).whereField("senderID", isEqualTo: senderId).getDocuments {  [weak self] snapshot, error in
            
            guard let self = self else { return }
            
            if error != nil {
                print("Error in your Connection")
            }
            else {
                
                guard let snapshot = snapshot else {
                    print("No Chat Room Founded")
                    return
                }
                
                let chatroom = snapshot.documents.compactMap { (query) -> ChatModel? in
                    return try! query.data(as: ChatModel.self)
                }
                
                guard var first = chatroom.first else { return }
                self.UpdateCounterOperatoin(chatroom: &first)
                
            }
        }
        
    }
    // ------------------------------------------------
    
    
    
    // MARK:- TODO:- This Method For Update ChatRooms with new message.
    func UpdateChatRoomsOperation (chatRoomId: String,lastMess: String) {
        FirebaseLayer.publicreadWithWhereCondtion(collectionName: chatCollection, key: RoomId, value: chatRoomId) { [weak self] snapshot in
            
            guard let self = self else { return }
            
            guard let snapshot = snapshot else {
                print("No Chat Room Founded")
                return
            }
            
            let chatroom = snapshot.documents.compactMap { (query) -> ChatModel? in
                return try! query.data(as: ChatModel.self)
            }
            
            for i in chatroom {
                var chat = i
                self.UpdateChatRoomOperation(chatroom: &chat, lastMess: lastMess)
            }
            
        }
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Check Typing Lestner From Firebase.
    private func isTypingCounter(type: Bool) {
        
        let currentUserId = GetCurrentUserData().uid
        
        FirebaseLayer.updateDocumnt(collectionName: typingCollection, documntId: ChatIdBahaviour.value, data: [currentUserId: type], completion: { _ in })
    }
    // ------------------------------------------------
    
    
    
    
    // MARK:- TODO:- This Method For Insert first 12 Messages To Mkmessages Behaviour.
    private func insertMessages(messageViewContrller: MessageViewController) {
        
        allLocalMessageObservable.asObservable().subscribe(onNext: {  [weak self] result in
            
            guard let self = self else { return }
            
            // This Section for Getting All Messages and show it for user.
            // ------------------------------------------------------------------
            /* print("Messages Found: \(result.count)")

            var mkmessages = Array<MKMessage>()

            let incomming = Incomming(messageViewController: messageViewContrller)

            for i in result {

                let mkmessage = incomming.createMCMessage(localMessage: i)
                mkmessages.append(mkmessage)
            }

            self.MessagesBahaviour.accept(mkmessages) */
            
            
            var mkmessages = Array<MKMessage>()
            let incomming = Incomming(messageViewController: messageViewContrller)
            
            self.max = result.count - self.displayNumber
            self.mini = self.max - self.numberOfShowMessgaes
            
            if self.mini < 0 {
                self.mini = 0
            }
            
            // Add 12 Messages from first to load.
            for i in self.mini ..< self.max {
                let mkmessage = incomming.createMCMessage(localMessage: result[i])
                mkmessages.append(mkmessage)
                self.displayNumber += 1
            }
            
            self.MessagesBahaviour.accept(mkmessages)
            self.alllocalMessgaes = result.count
            
            
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    
    
    
    // MARK:- TODO:- This Method For Insert Last Message To Mkmessages Behaviour.
    private func insertOneMessages(messageViewContrller: MessageViewController) {
        
        allLocalMessageObservable.asObservable().subscribe(onNext: {  [weak self] result in
            
            guard let self = self else { return }
            
            let mostdate = result.reduce(result[0], {$0.date > $1.date ? $0 : $1 })
            
            let incomming = Incomming(messageViewController: messageViewContrller)
            let newestmessage = incomming.createMCMessage(localMessage: mostdate)
            
            var messagesAddednew = self.MessagesBahaviour.value
            messagesAddednew.append(newestmessage)
            
            self.MessagesBahaviour.accept(messagesAddednew)
            self.responseBehaviour.accept(true)
            self.displayNumber += 1
            
            
            
        }).disposed(by: disposebag)
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
    
    
    // MARK:- TODO:- This Method Help To Get Last Current Date From Realm Database.
    private func LastMessageDate() -> Date {
        
        var lastmessage: Date?
        
        allLocalMessageBehaviour.subscribe(onNext: { messages in
            
            lastmessage = messages.last?.date ?? Date()
            
        }).disposed(by: disposebag)
        
        return Calendar.current.date(byAdding: .second, value: 1, to: lastmessage!) ?? lastmessage!
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For UpdateCounter in chatRoom.
    private func UpdateCounterOperatoin(chatroom: inout ChatModel) {
        
        chatroom.unreadCounter = 0
        
        do {
            try FirebaseLayer.refernceCollection(chatCollection).document(chatroom.id).setData(from: chatroom) {
                error in
                
                if error != nil {
                    print("Error in update")
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- Update ChatRoom with new message
    private func UpdateChatRoomOperation (chatroom: inout ChatModel, lastMess: String) {
        
        let currentId = self.GetCurrentUserData().uid
        
        if chatroom.senderID != currentId {
            chatroom.unreadCounter += 1
        }
        
        chatroom.lastMessage = lastMess
        chatroom.date = Date()
        
        do {
            try FirebaseLayer.refernceCollection(chatCollection).document(chatroom.id).setData(from: chatroom)
        } catch {
            print(error.localizedDescription)
        }
    }
    // ------------------------------------------------
    
}
