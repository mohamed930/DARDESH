//
//  UsersViewModel.swift
//  DARDESH
//
//  Created by Mohamed Ali on 10/07/2021.
//

import Foundation
import RxSwift
import RxCocoa
import ProgressHUD

class UsersViewModel {
    
    var SearchTextFieldBehaviour = BehaviorRelay<String>(value: "")
    
    var isLoadingBehaviour = BehaviorRelay<Bool>(value: false)
    
    var UsersModelSubject       = BehaviorRelay<[UserModel]>(value: [])
    var BackupUsersModelSubject = BehaviorRelay<[UserModel]>(value: [])
    var FilteredGettenData      = BehaviorRelay<[UserModel]>(value: [])
    
    let disposebag = DisposeBag()
    
    // MARK:- TODO:- Make Validation Oberval here.
    var isSearchBehaviour : Observable<Bool> {
        return SearchTextFieldBehaviour.asObservable().map { search -> Bool in
            let isSearchEmpty = search.trimmingCharacters(in: .whitespaces).isEmpty
            
            return isSearchEmpty
        }
    }
    
    // MARK:- TODO:- This Method For Getting All Users from Firebase.
    func GetAllUsersOperation() {
        
        var arr = Array<UserModel>()
        
        isLoadingBehaviour.accept(true)
        
        FirebaseLayer.publicreadWithoutWhereCondtion(collectionName: userCollection) { query, error in
            guard let query = query else {
                // Show Empty Table
                self.isLoadingBehaviour.accept(false)
                print("SnapShot is Empty!")
                return
            }
            
            guard error != nil else {
                
                for i in query.documents {
                    
                    if i.get("uid") as! String == userID {
                        continue
                    }
                    else {
                        let ob = UserModel(uid: i.get("uid") as! String, email: i.get("uid") as! String, UserName: i.get("UserName") as! String, Image: i.get("Image") as! String, status: i.get("status") as! String, pushid: i.get("pushid") as! String)
                        
                        arr.append(ob)
                    }
                    
                    
                }
                
                self.UsersModelSubject.accept(arr)
                self.BackupUsersModelSubject.accept(arr)
                self.isLoadingBehaviour.accept(false)
                
                return
            }
            
            self.isLoadingBehaviour.accept(false)
            ProgressHUD.showError("errorMess".localized, interaction: true)
            
        }
        
    }
    // ------------------------------------------------
    
    
    func SearchOperation() {
        let queryResult = SearchTextFieldBehaviour.map { query in
            self.UsersModelSubject.value.filter { user in
                query.isEmpty || user.UserName.lowercased().contains(query.lowercased())
            }
        }
        
        queryResult.asObservable().subscribe(onNext: { [weak self] usermodel in
         
            guard let self = self else { return }
         
         self.UsersModelSubject.accept(usermodel)
        }).disposed(by: disposebag)
    }
    
}
