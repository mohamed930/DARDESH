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
    
    var isLoadingBehaviour = BehaviorRelay<Bool>(value: false)
    
    private var UsersModelSubject = PublishSubject<[UserModel]>()
    var UsersModelObservable: Observable<[UserModel]> {
        return UsersModelSubject
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
                    
                    let ob = UserModel(uid: i.get("uid") as! String, email: i.get("uid") as! String, UserName: i.get("UserName") as! String, Image: i.get("Image") as! String, status: i.get("status") as! String, pushid: i.get("pushid") as! String)
                    
                    arr.append(ob)
                    
                }
                
                self.UsersModelSubject.onNext(arr)
                self.isLoadingBehaviour.accept(false)
                
                return
            }
            
            self.isLoadingBehaviour.accept(false)
            ProgressHUD.showError("errorMess".localized, interaction: true)
            
        }
        
    }
    // ------------------------------------------------
    
}
