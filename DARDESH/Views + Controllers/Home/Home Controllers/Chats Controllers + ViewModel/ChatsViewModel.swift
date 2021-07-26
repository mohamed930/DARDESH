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
    
    // MARK:- TODO:- This Sektion For intialise new RxSwift Varibles.
    var isloadingBeviour = BehaviorRelay<Bool>(value: false)
    
    private var ChatsModelSubject = PublishSubject<[ChatModel]>()
    var ChatsModelObservable: Observable<[ChatModel]> {
        return ChatsModelSubject
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Getting Data From Firebase.
    func GetDataOperation() {
        
        isloadingBeviour.accept(true)
        
        let names = ["John","Koncer","Said"]
        let LastMessageLabel = ["Hi Ali, how are you? let's meet tomorrow","What'sapp Man","you are kidden me!"]
        let dates = ["19/07/2021 03:22 PM","02/04/2021 03:28 PM","30/08/2021 11:28 PM"]
        let unreadedCount = [0,2,1]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm a"
        
        var chats = Array<ChatModel>()
        
        for i in 0..<3 {
            
            let date = dateFormatter.date(from: dates[i])!
            
            let ob = ChatModel(id: "10", chatRoomId: "00", senderID: "01", senderName: names[i], RecevierID: "02", RecevierName: names[i], date: date, membersId: [], lastMessage: LastMessageLabel[i], unreadCounter: unreadedCount[i], AvatarLink: "icon")
            
            chats.append(ob)
        }
        
        self.isloadingBeviour.accept(false)
        self.ChatsModelSubject.onNext(chats)
        
    }
    // ------------------------------------------------
    
}
