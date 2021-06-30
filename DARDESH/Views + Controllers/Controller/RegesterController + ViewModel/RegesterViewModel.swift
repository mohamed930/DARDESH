//
//  RegesterViewModel.swift
//  DARDESH
//
//  Created by Mohamed Ali on 29/06/2021.
//

import Foundation
import RxCocoa
import RxSwift
import FirebaseAuth

class RegesterViewModel {
    
    var emailBehaviour = BehaviorRelay<String>(value: "")
    var passwordBehaviour = BehaviorRelay<String>(value: "")
    var confirmPasswordBehaviour = BehaviorRelay<String>(value: "")
    
    var loadingBehaviour = BehaviorRelay<Bool>(value: false)
    
    var isCreatedAccount = PublishSubject<String>()
    var CreatedModelSubjectObserval:Observable<String> {
        return isCreatedAccount
    }
    
    
    var isEmailBehaviour : Observable<Bool> {
        return emailBehaviour.asObservable().map { email -> Bool in
            let isEmailEmpty = email.trimmingCharacters(in: .whitespaces).isEmpty
            
            return isEmailEmpty
        }
    }
    
    var isPasswordBehaviour : Observable<Bool> {
        return passwordBehaviour.asObservable().map { password -> Bool in
            let isPasswordEmpty = password.trimmingCharacters(in: .whitespaces).isEmpty
            
            return isPasswordEmpty
        }
    }
    
    var isConfirmPasswordBehaviour : Observable<Bool> {
        return confirmPasswordBehaviour.asObservable().map { password -> Bool in
            let isConfirmPasswordEmpty = password.trimmingCharacters(in: .whitespaces).isEmpty
            
            return isConfirmPasswordEmpty
        }
    }
    
    var isRegesterButtonEnabled: Observable<Bool> {
        return Observable.combineLatest(isEmailBehaviour,isPasswordBehaviour,isConfirmPasswordBehaviour) { [weak self]
            emailEmpty , passwordEmpty, ConfirmPassword in
            
            let loginValid = !emailEmpty && !passwordEmpty && !ConfirmPassword
            
            let regesterValid = (self!.passwordBehaviour.value == self!.confirmPasswordBehaviour.value)
            
            let result = loginValid && regesterValid
            
            return result
        }
    }
    
    func RegesterOperation() {
        
        loadingBehaviour.accept(true)
        
        FirebaseLayer.createAccount(Email: emailBehaviour.value, Password: passwordBehaviour.value) { [weak self] value , auth in
            
            guard let self = self else { return }
            
            if value == "Success" {
                let usermodel = UserModel(uid: auth?.user.uid ?? "NoID", email: self.emailBehaviour.value, UserName: self.emailBehaviour.value, Image: defaultAvatar, status: "Avaliable")
                
                let userData = [
                                    "id": usermodel.uid,
                                    "email": usermodel.email,
                                    "username": usermodel.UserName,
                                    "image": usermodel.Image,
                                    "status": usermodel.status
                               ]
                
                FirebaseLayer.addData(collectionName: "User", data: userData) { response in
                    if response == "Success" {
                        self.loadingBehaviour.accept(false)
                        self.isCreatedAccount.onNext("Success")
                    }
                    else {
                        self.loadingBehaviour.accept(false)
                        self.isCreatedAccount.onNext("Failed")
                    }
                }
            }
            else {
                self.loadingBehaviour.accept(false)
                self.isCreatedAccount.onNext("Failed")
            }
        }
        
    }
    
}
