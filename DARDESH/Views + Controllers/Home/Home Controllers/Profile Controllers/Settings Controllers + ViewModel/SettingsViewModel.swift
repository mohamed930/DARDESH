//
//  SettingsViewModel.swift
//  DARDESH
//
//  Created by Mohamed Ali on 01/07/2021.
//

import Foundation
import RxCocoa
import RxSwift
import Kingfisher
import ProgressHUD

class SettingsViewModel {
    
    // MARK:- TODO:- intialise new rx varibles here.
    var isloading = BehaviorRelay<Bool>(value: false)
    
    private var CollectDataBehaviour = PublishSubject<UserModel>()
    var CollectDataModelSubjectObserval:Observable<UserModel> {
        return CollectDataBehaviour
    }
    
    private var isSignoutBehaviour = PublishSubject<Bool>()
    var isSignoutModelSubjectObserval:Observable<Bool> {
        return isSignoutBehaviour
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method for Decode UserDefault and send object to Observable.
    func loadUserDataOperation() {
        
        guard let result = UserDefaultsMethods.loadDataFromUserDefaults(Key: currentUser, className: UserModel.self) else  {
            print("Error")
            return
        }
        
        CollectDataBehaviour.onNext(result)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method for userlog out from firebase.
    func logoutOperation() {
        
        isloading.accept(true)
        
        FirebaseLayer.LogoutUser { [weak self] mess in
            
            guard let self = self else { return }
            
            if mess == "Sign out Successfully" {
                
                // Remove UserDefaults.
                self.RemoveUserDefault()
            }
            else {
                self.isloading.accept(false)
                ProgressHUD.showError(mess)
            }
        }
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This method for clear userdefault from userdata.
    private func RemoveUserDefault() {
        UserDefaults.standard.removeObject(forKey: currentUser)
        UserDefaults.standard.synchronize()
        
        //check Userdefault is exsist or not to send success or failed.
        if UserDefaults.standard.object(forKey: currentUser) as? Data == nil {
            // it's success.
            isloading.accept(false)
            isSignoutBehaviour.onNext(true)
        }
        else {
            // it's failed.
            isloading.accept(false)
            isSignoutBehaviour.onNext(false)
        }
    }
    // ------------------------------------------------
    
}
