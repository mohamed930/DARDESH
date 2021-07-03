//
//  LoginViewModel.swift
//  DARDESH
//
//  Created by Mohamed Ali on 29/06/2021.
//

import Foundation
import RxCocoa
import RxSwift
import ProgressHUD
import FirebaseAuth

class LoginViewModel {
    
    // MARK:- TODO:- Intialize rxswift varible
    var EmailBehaviour = BehaviorRelay<String>(value: "")
    var PasswordBehaviour = BehaviorRelay<String>(value: "")
    var loadingBehaviour = BehaviorRelay<Bool>(value: false)
    
    private var loginBehaviour = PublishSubject<String>()
    var loginsModelSubjectObserval:Observable<String> {
        return loginBehaviour
    }
    
    private var resetePassBehaviour = PublishSubject<String>()
    var resetePasssModelSubjectObserval:Observable<String> {
        return resetePassBehaviour
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- Make Validation Oberval here.
    var isEmailBehaviour : Observable<Bool> {
        return EmailBehaviour.asObservable().map { email -> Bool in
            let isEmailEmpty = email.trimmingCharacters(in: .whitespaces).isEmpty
            
            return isEmailEmpty
        }
    }
    
    var isPasswordBehaviour : Observable<Bool> {
        return PasswordBehaviour.asObservable().map { password -> Bool in
            let isPasswordEmpty = password.trimmingCharacters(in: .whitespaces).isEmpty
            
            return isPasswordEmpty
        }
    }
    
    var isLoginButtonEnabled: Observable<Bool> {
        return Observable.combineLatest(isEmailBehaviour,isPasswordBehaviour) {
            emailEmpty , passwordEmpty in
            let loginValid = !emailEmpty && !passwordEmpty
            
            return loginValid
        }
    }
    
    
    var isPasswordResetrBehaviour : Observable<Bool> {
        return EmailBehaviour.asObservable().map { email -> Bool in
            let isEmailEmpty = email.trimmingCharacters(in: .whitespaces).isEmpty
            
            return !isEmailEmpty
        }
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- method for login with email&password
    func LoginOperation() {
        
        loadingBehaviour.accept(true)
        
        FirebaseLayer.MakeLogin(Email: EmailBehaviour.value, Password: PasswordBehaviour.value) { [weak self] auth, error in
            
            guard let self = self else { return }
            
            if error == nil && auth!.user.isEmailVerified {
            
                // download data from firestore
                self.DownloadData(auth1: auth!)
            }
            else {
                // send to load to stop and send response failed
                self.loadingBehaviour.accept(false)
                self.loginBehaviour.onNext(error?.localizedDescription ?? "There is no connection")
            }
            
        }
        
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- this method for resete password agter entring email
    func ResetPasswordOperation() {
        
        loadingBehaviour.accept(true)
        
        FirebaseLayer.resetPassword(Email: EmailBehaviour.value) {  [weak self] mess in
            
            guard let self = self else { return }
            
            if mess == "Sent Successed" {
                self.loadingBehaviour.accept(false)
                self.resetePassBehaviour.onNext("Email was sent please follow steps to resete password")
            }
            else {
                self.loadingBehaviour.accept(false)
                self.resetePassBehaviour.onNext(mess)
                print("F: \(mess)")
            }
        }
        
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This method for download data from firestore
    private func DownloadData(auth1: AuthDataResult) {
        
        FirebaseLayer.publicreadWithWhereCondtion(collectionName: userCollection, key: "uid", value: auth1.user.uid) { [weak self] snap in
            
            guard let self = self else { return }
            
            for doc in snap.documents {
                
                // Download Data from Firestore
                let user = UserModel(uid: doc.get("uid") as! String, email: doc.get("email") as! String, UserName: doc.get("UserName") as! String, Image: doc.get("Image") as! String, status: doc.get("status") as! String)
                
                // Save Data in to userdefaults
                self.SaveUserDataLocally(user)
            }
        }
    }
    // ------------------------------------------------
    
    
    
    // MARK:- TODO:- this method for save user datalocally
    private func SaveUserDataLocally(_ user: UserModel) {
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(user)
            UserDefaults.standard.setValue(data, forKey: currentUser)
            
            // send to load to stop and send response success
            self.loadingBehaviour.accept(false)
            self.loginBehaviour.onNext("Success")
        } catch {
            print(error.localizedDescription)
            
            self.loadingBehaviour.accept(false)
            self.loginBehaviour.onNext(error.localizedDescription)
        }
        
    }
    // ------------------------------------------------
}
