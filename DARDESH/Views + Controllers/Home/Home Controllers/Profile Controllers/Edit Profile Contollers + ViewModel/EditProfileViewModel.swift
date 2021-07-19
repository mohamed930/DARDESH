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
    var PickedImageBehaviour = BehaviorRelay<UIImage>(value: UIImage(named: "photoPlaceholder")!)
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
        
        guard let user = UserDefaultsMethods.loadDataFromUserDefaults(Key: currentUser, className: UserModel.self) else { return }
        
        CollectDataBehaviour.onNext(user)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Updating Username.
    func UpdateUserName() {
        
        isloadingBehaviour.accept(true)
        
        FirebaseLayer.updateDocumnt(collectionName: userCollection, documntId: userID, data: ["UserName": UserNameBehaviour.value]) { [weak self] Result in
            
            guard let self = self else { return }
            
            if Result {
                // Update User Defaults Data
                guard let userData = UserDefaultsMethods.loadDataFromUserDefaults(Key: currentUser, className: UserModel.self) else { return }
                
                // Second Updata Data to UserDefauls
                let usermodel = UserModel(uid: userData.uid, email: userData.email, UserName: self.UserNameBehaviour.value , Image: userData.Image , status: userData.status , pushid: userData.pushid)
                
                self.UpdateUserDefaulsMethod(userModel: usermodel)
            }
            else {
                self.isloadingBehaviour.accept(false)
                self.UpdateResponseBehaviour.onNext(false)
            }
        }
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Updating ProfileImage.
    func UpdateProfileImageOperation() {
        
        isloadingBehaviour.accept(true)
        
//        let date = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
//        let result = formatter.string(from: date)
        
        
        let imgName = imageFolder + "/ProfileImages/" + userID
        
        FirebaseLayer.uploadMedia(ImageName: imgName, PickedImage: PickedImageBehaviour.value) { [weak self] urlImg in
            
            guard let self = self else { return }
            
            if urlImg == nil {
                self.isloadingBehaviour.accept(false)
                self.UpdateResponseBehaviour.onNext(false)
            }
            else {
                
                // UpdateLink on firebase.
                FirebaseLayer.updateDocumnt(collectionName: userCollection, documntId: userID, data: ["Image": urlImg!]) { [weak self] Result in
                    
                    guard let self = self else { return }
                    
                    if Result {
                        // Update User Defaults Data
                        guard let userData = UserDefaultsMethods.loadDataFromUserDefaults(Key: currentUser, className: UserModel.self) else { return }
                        
                        // Second Updata Data to UserDefauls
                        let usermodel = UserModel(uid: userData.uid, email: userData.email, UserName: userData.UserName , Image: urlImg! , status: userData.status , pushid: userData.pushid)
                        
                        self.UpdateUserDefaulsMethod(userModel: usermodel)
                    }
                    else {
//                        self.isloadingBehaviour.accept(false)
                        self.UpdateResponseBehaviour.onNext(false)
                    }
                }
                
            }
        }
        
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- Update UserDefualts Method.
    private func UpdateUserDefaulsMethod(userModel: UserModel) {
        
        UserDefaultsMethods.SaveDataToUserDefaults(Key: currentUser, userModel) { response in
            if response == "Success" {
                self.isloadingBehaviour.accept(false)
                self.UpdateResponseBehaviour.onNext(true)
            }
            else {
                print(response)
                self.isloadingBehaviour.accept(false)
                self.UpdateResponseBehaviour.onNext(false)
            }
        }
        
    }
    
}
