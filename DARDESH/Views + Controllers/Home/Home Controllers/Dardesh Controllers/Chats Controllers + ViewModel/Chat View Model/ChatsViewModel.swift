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
    var TextFieldBehaviour = BehaviorRelay<String>(value: "")
    
    var ChatsModelSubject = BehaviorRelay<[ChatModel]>(value: [])
    var BackupChatsModelSubject = BehaviorRelay<[ChatModel]>(value: [])
    var FilteredChatsModelSubject = BehaviorRelay<[ChatModel]>(value: [])
    
    
    let disposebag = DisposeBag()
    // ------------------------------------------------
    
    // MARK:- TODO:- Make Validation Oberval here.
    var isSearchBehaviour : Observable<Bool> {
        return TextFieldBehaviour.asObservable().map { search -> Bool in
            let isSearchEmpty = search.trimmingCharacters(in: .whitespaces).isEmpty
            
            return isSearchEmpty
        }
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Getting Data From Firebase.
    func GetDataOperation() {
        
        isloadingBeviour.accept(true)
        
        FirebaseLayer.publicRealtimereadWithWhereCondtion(collectionName: chatCollection, key: "senderID", value: userID) { [weak self] snapshot in
            
            guard let snapshot = snapshot else {
                print("No Element!")
                return
            }
            
            guard let self = self else { return }
            
            let data = snapshot.documents.compactMap { (snapshot) -> ChatModel? in
                return try? snapshot.data(as: ChatModel.self)
            }
            
            var chatrooms = Array<ChatModel>()
            
            for i in data {
                if i.lastMessage != "" {
                    chatrooms.append(i)
                }
            }
            
            chatrooms.sort {
                $0.date! > $1.date!
            }
            
            self.ChatsModelSubject.accept(chatrooms)
            self.BackupChatsModelSubject.accept(chatrooms)
            self.isloadingBeviour.accept(false)
        }
        
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Search in Array.
    func SearchOperation() {
        
        let queryResult = TextFieldBehaviour.map { query in
            self.ChatsModelSubject.value.filter { chat in
                query.isEmpty || chat.RecevierName.lowercased().contains(query.lowercased())
            }
        }
        
        queryResult.asObservable().subscribe(onNext: { [weak self] chatmodel in
         
            guard let self = self else { return }
         
         self.ChatsModelSubject.accept(chatmodel)
        }).disposed(by: disposebag)
        
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method Filter ReceiverData.
    func GetReceverData (UsersId: [String], completion: @escaping ([UserModel]) -> Void){
        
        var receiverid = String()
        
        for i in UsersId {
            if i != userID {
                receiverid = i
                break
            }
        }
        
        FirebaseLayer.publicreadWithWhereCondtion(collectionName: userCollection, key: "uid", value: receiverid) { snapshot in
            
            guard let snapshot = snapshot else  { return }
            
            let data = snapshot.documents.compactMap { (snapshot) -> UserModel? in
                return try? snapshot.data(as: UserModel.self)
            }
            
            completion(data)
            
        }
        
        
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Delete index from Chat Cell.
    func DeleteOperation(at indexPath: IndexPath) {
        
        // Get the current All And Add to arr
        var Arr = self.ChatsModelSubject.value
        
        // Remove From Firebase.
        DeleteFromFirebase(id: Arr[indexPath.row].id)
        
        // Remove the item from the section at the specified indexPath
        Arr.remove(at: indexPath.row)
                
        // Inform your subject with the new changes
        self.ChatsModelSubject.accept(Arr)
        self.BackupChatsModelSubject.accept(Arr)
    }
    // ------------------------------------------------
    
    
    
    // MARK:- TODO:- This Method For Delete Chat from Firebase.
    private func DeleteFromFirebase(id: String) {
        
        FirebaseLayer.refernceCollection(chatCollection).document(id).delete()
        
    }
    // ------------------------------------------------
    
}
