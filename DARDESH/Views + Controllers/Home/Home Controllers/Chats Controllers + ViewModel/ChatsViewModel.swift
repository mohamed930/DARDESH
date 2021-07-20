//
//  ChatsViewModel.swift
//  DARDESH
//
//  Created by Mohamed Ali on 01/07/2021.
//

import Foundation
import RxSwift
import RxCocoa

class ChatsViewModel {
    
    var isloadingBeviour = BehaviorRelay<Bool>(value: false)
    
    private var ChatsModelSubject = PublishSubject<[ChatModel]>()
    var ChatsModelObservable: Observable<[ChatModel]> {
        return ChatsModelSubject
    }
    
    func GetDataOperation() {
        
        isloadingBeviour.accept(true)
        
        let names = ["John","Koncer","Said"]
        let LastMessageLabel = ["Hi","What'sapp Man","you are kidden me!"]
        let dates = ["10/03/2020","02/04/1998","30/10/2021"]
        let unreadedCount = [0,2,1]
        
        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        var chats = Array<ChatModel>()
        
        for i in 0..<3 {
            
            let date = dateFormatter.date(from: dates[i])!
            
            let ob = ChatModel(id: "10", chatRoomId: "00", senderID: "01", senderName: names[i], RecevierID: "02", RecevierName: names[i], date: date, membersId: [], lastMessage: LastMessageLabel[i], unreadCounter: unreadedCount[i], AvatarLink: "icon")
            
            chats.append(ob)
        }
        
        self.isloadingBeviour.accept(false)
        self.ChatsModelSubject.onNext(chats)
        
    }
    
}
