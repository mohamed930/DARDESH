//
//  StatusViewModel.swift
//  DARDESH
//
//  Created by Mohamed Ali on 07/07/2021.
//

import Foundation
import RxSwift
import RxCocoa
import ProgressHUD

class StatusViewModel {
    
    // MARK:- TODO:- This Sektion For initialise New RxSwift Varibles.
    var checkmarksStatus = BehaviorRelay<String>(value: "")
    
    private var StatusModelSubject = PublishSubject<[StatusModel]>()
    var StatusModelObservable: Observable<[StatusModel]> {
        return StatusModelSubject
    }
    
    var isloading = BehaviorRelay<Bool>(value: false)
    var CurrentItemChangedIndexBehaviour = BehaviorRelay<Int>(value: -1)
    var CurrentItemChangedStatusBehaviour = BehaviorRelay<Bool>(value: false)
    var StatusNameBehaviour = BehaviorRelay<String>(value: "")
    // ------------------------------------------------
    
    // MARK:- TODO:- This for Initial Array to load page to checkMarks your current status.
    func GetData() {
        
        let data = ["Avaliable","Busy","At School","At The Movies","At Work","Battary About to die","Can't Talk","In a Meating","At the gym","Sleeping","Ungent calls Only"]
        
        var statusModels = Array<StatusModel>()
        
        for i in data {
            if i == checkmarksStatus.value {
                let ob = StatusModel(statusName: i, checkMark: true)
                statusModels.append(ob)
            }
            else {
                let ob = StatusModel(statusName: i, checkMark: false)
                statusModels.append(ob)
            }
        }
        
        StatusModelSubject.onNext(statusModels)
        
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- this method for calling in ViewController to update your status.
    func UpdateOperation() {
        UpdateDataOnUI()
        UpdateStatusOnFirebase()
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- First update your UI cell reaload it.
    private func UpdateDataOnUI() {
        
        // make elements
        let data = ["Avaliable","Busy","At School","At The Movies","At Work","Battary About to die","Can't Talk","In a Meating","At the gym","Sleeping","Ungent calls Only"]
        
        var statusModels = Array<StatusModel>()
        
        for i in 0..<data.count {
            // check you are in the current checked cell index.row
            if data[i] == data[CurrentItemChangedIndexBehaviour.value] {
                // make it checked (true)
                let ob = StatusModel(statusName: data[i], checkMark: CurrentItemChangedStatusBehaviour.value)
                statusModels.append(ob)
            }
            else {
                // and make all cells not checked (false)
                let ob = StatusModel(statusName: data[i], checkMark: false)
                statusModels.append(ob)
            }
        }
        
        // add new array to UI.
        StatusModelSubject.onNext(statusModels)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method for updating your status into firebase.
    private func UpdateStatusOnFirebase() {
        
        isloading.accept(true)
        
        // use firebaselayer and update status to statusNameBehaviourText.
        FirebaseLayer.updateDocumnt(collectionName: userCollection, documntId: userID, data: ["status": StatusNameBehaviour.value]) { [weak self] resposnse in
            
            guard let self = self else { return }
            
            if resposnse {
                self.UpdateUserDefaulsMethod()
            }
            else {
                self.isloading.accept(false)
                ProgressHUD.showError("Connection".localized, interaction: true)
            }
        }
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- Update UserDefualts Method.
    private func UpdateUserDefaulsMethod() {
        
        // Get User Defaults Data
        guard let userData = UserDefaultsMethods.loadDataFromUserDefaults(Key: currentUser, className: UserModel.self) else { return }
        
        // Second Updata Data to UserDefauls
        let usermodel = UserModel(uid: userData.uid, email: userData.email, UserName: userData.UserName , Image: userData.Image , status: self.StatusNameBehaviour.value , pushid: userData.pushid)
        
        UserDefaultsMethods.SaveDataToUserDefaults(Key: currentUser, usermodel) { response in
            if response == "Success" {
                print("Saved Here")
                self.isloading.accept(false)
            }
            else {
                print(response)
                self.isloading.accept(false)
            }
        }
        
    }
    
}
