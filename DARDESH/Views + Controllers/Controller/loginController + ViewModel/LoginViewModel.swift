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

class LoginViewModel {
    
    var EmailBehaviour = BehaviorRelay<String>(value: "")
    var PasswordBehaviour = BehaviorRelay<String>(value: "")
    
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
    
    var loadingBehaviour = BehaviorRelay<Bool>(value: false)
    
    private var loginBehaviour = PublishSubject<String>()
    var loginsModelSubjectObserval:Observable<String> {
        return loginBehaviour
    }
    
    func LoginOperation() {
        
        loadingBehaviour.accept(true)
        
        FirebaseLayer.MakeLogin(Email: EmailBehaviour.value, Password: PasswordBehaviour.value) { [weak self] message in
            
            guard let self = self else { return }
            
            if message == "Success" {
                self.loadingBehaviour.accept(false)
                self.loginBehaviour.onNext("Success")
            }
            else {
                self.loadingBehaviour.accept(false)
                self.loginBehaviour.onNext("Failed")
            }
        }
        
    }
    
    
}
