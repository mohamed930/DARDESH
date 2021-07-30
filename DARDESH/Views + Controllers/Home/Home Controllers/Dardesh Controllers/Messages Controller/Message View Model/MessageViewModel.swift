//
//  MessageViewModel.swift
//  DARDESH
//
//  Created by Mohamed Ali on 27/07/2021.
//

import Foundation
import RxSwift
import RxCocoa

class MessageViewModel {
    
    // MARK:- TODO:- Initialise new rx varible here.
    var inputTextFieldBahaviour = BehaviorRelay<String>(value: "")
    
    var ChatIdBahaviour = BehaviorRelay<String>(value: "")
    var recipientidBahaviour = BehaviorRelay<String>(value: "")
    var recipientNameBahaviour = BehaviorRelay<String>(value: "")
    
    var MessagesBahaviour = BehaviorRelay<[MKMessage]>(value: [])
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
    
}
