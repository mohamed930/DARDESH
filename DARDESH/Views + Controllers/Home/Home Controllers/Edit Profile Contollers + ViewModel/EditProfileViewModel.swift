//
//  EditProfileViewModel.swift
//  DARDESH
//
//  Created by Mohamed Ali on 04/07/2021.
//

import Foundation
import RxCocoa
import RxSwift
import ProgressHUD
import FirebaseAuth
import FirebaseFirestore

class EditProfileViewModel {
    
    // MARK:- TODO:- This Varibles here.
    var UserNameBehaviour  = BehaviorRelay<String>(value: "")
    var isloadingBehaviour = BehaviorRelay<Bool>(value: false)
    
    private var CollectDataBehaviour = PublishSubject<UserModel>()
    var CollectDataModelSubjectObserval:Observable<UserModel> {
        return CollectDataBehaviour
    }
    
    private var UpdateResponseBehaviour = PublishSubject<Bool>()
    var UpdateResponseModelSubjectObserval:Observable<Bool> {
        return UpdateResponseBehaviour
    }
    // ------------------------------------------------
    
    let disposebag = DisposeBag()
    
    // MARK:- TODO:- This Method for Decode UserDefault and send object to Observable.
    func loadUserDataOperation() {
        
         let savedPerson = UserDefaults.standard.object(forKey: currentUser) as? Data
         let decoder = JSONDecoder()
         if let loadedPerson = try? decoder.decode(UserModel.self, from: savedPerson!) {
            CollectDataBehaviour.onNext(loadedPerson)
         }
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Updating Username.
    func UpdateUserName() {
        
        isloadingBehaviour.accept(true)
        
        FirebaseLayer.updateDocumnt(collectionName: userCollection, documntId: Auth.auth().currentUser!.uid, data: ["UserName": UserNameBehaviour.value]) { [weak self] Result in
            
            guard let self = self else { return }
            
            if Result {
                self.UpdateUserDefault()
            }
            else {
                self.isloadingBehaviour.accept(false)
                self.UpdateResponseBehaviour.onNext(false)
            }
        }
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- Update UserDefault loccally.
    private func UpdateUserDefault () {
        
        let savedPerson = UserDefaults.standard.object(forKey: currentUser) as? Data
        let decoder = JSONDecoder()
        if let userData = try? decoder.decode(UserModel.self, from: savedPerson!) {
           
            let usermodel = UserModel(uid: userData.uid, email: userData.email, UserName: self.UserNameBehaviour.value , Image: userData.Image , status: userData.status , pushid: userData.pushid)
            
            self.SaveUserLocally(usermodel)
        }
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This method for saving UserData to UserDefaults.
    private func SaveUserLocally (_ user: UserModel) {
        
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(user)
            UserDefaults.standard.setValue(data, forKey: currentUser)
            print("Saved Here")
            self.isloadingBehaviour.accept(false)
            self.UpdateResponseBehaviour.onNext(true)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    // ------------------------------------------------
    
}
