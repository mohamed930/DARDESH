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
    
    // MARK:- TODO:- intialise varibles here
    var emailBehaviour = BehaviorRelay<String>(value: "")
    var passwordBehaviour = BehaviorRelay<String>(value: "")
    var confirmPasswordBehaviour = BehaviorRelay<String>(value: "")
    
    var loadingBehaviour = BehaviorRelay<Bool>(value: false)
    
    var isCreatedAccount = PublishSubject<String>()
    var CreatedModelSubjectObserval:Observable<String> {
        return isCreatedAccount
    }
    
    var isSentEmailVerify = PublishSubject<String>()
    var SentEmailVerifyModelSubjectObserval:Observable<String> {
        return isCreatedAccount
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- Make Validation Oberval here.
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
    // ------------------------------------------------
    
    // MARK:- TODO:- This method for regester
    func RegesterOperation() {
        
        loadingBehaviour.accept(true)
        
        // First Create Account into Auth table
        FirebaseLayer.createAccount(Email: emailBehaviour.value, Password: passwordBehaviour.value) { [weak self] value , auth in
            
            guard let self = self else { return }
            
            if value == "Success" {
                
                self.SendEmailVerfie(auth: auth)
                
            }
            else {
                self.loadingBehaviour.accept(false)
                self.isCreatedAccount.onNext(value)
            }
        }
        
    }
    // ------------------------------------------------

    // MARK:- TODO:- This Method For Resend Email Verfication.
    func SendEmailVerfication() {
        
        loadingBehaviour.accept(true)
        
        FirebaseLayer.SendEmailVerifcation { [weak self] mess in
            
            guard let self = self else { return }
            
            self.loadingBehaviour.accept(false)
            self.isSentEmailVerify.onNext(mess)
        }
        
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- method after auth verfiy email
    private func SendEmailVerfie(auth: AuthDataResult?) {
        
        // Second Send Verification to user to active email.
        auth?.user.sendEmailVerification(completion: {  [weak self] error in
            
            guard let self = self else { return }
            
            if error != nil {
                self.loadingBehaviour.accept(false)
                self.isCreatedAccount.onNext(error!.localizedDescription)
            }
            else {
                self.WriteNewUser(auth: auth)
            }
        })
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- thrid write user data to firestore.
    private func WriteNewUser(auth: AuthDataResult?) {
        
        // thrid write user data to firestore.
        
        let user = UserModel(uid: auth?.user.uid ?? "NoID", email: self.emailBehaviour.value, UserName: self.emailBehaviour.value, Image: defaultAvatar, status: "Avaliable",pushid: "")
        
        do {
            try FirebaseLayer.refernceCollection(userCollection).document(auth!.user.uid).setData(from: user) {
                error in
                
                if error != nil {
                    print("Error in writing")
                    self.loadingBehaviour.accept(false)
                    self.isCreatedAccount.onNext(error!.localizedDescription)
                }
                else {
                    self.loadingBehaviour.accept(false)
                    self.isCreatedAccount.onNext("Success")
                    
                    // After saved to firestore save locally
                    self.SaveUserLocally(user)
                }
                
            }
        }
        catch {
            print("Error in converting")
            self.loadingBehaviour.accept(false)
            self.isCreatedAccount.onNext(error.localizedDescription)
        }
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This method for saving UserData to UserDefaults.
    private func SaveUserLocally (_ user: UserModel) {
        
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(user)
            UserDefaults.standard.setValue(data, forKey: currentUser)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    // ------------------------------------------------
    
}
