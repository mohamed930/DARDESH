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
        UpdateStatusOnUserDefault()
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
                self.UpdateStatusOnUserDefault()
            }
            else {
                self.isloading.accept(false)
                ProgressHUD.showError("Connection".localized, interaction: true)
            }
        }
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- Update stauts into UserDefault only.
    private func UpdateStatusOnUserDefault() {
        
        let savedPerson = UserDefaults.standard.object(forKey: currentUser) as? Data
        let decoder = JSONDecoder()
        if let userData = try? decoder.decode(UserModel.self, from: savedPerson!) {
           
            // get data from userdefaults and change status with new status that you are checked.
            let usermodel = UserModel(uid: userData.uid, email: userData.email, UserName: userData.UserName , Image: userData.Image , status: self.StatusNameBehaviour.value , pushid: userData.pushid)
            
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
            self.isloading.accept(false)
        } catch {
            print(error.localizedDescription)
            ProgressHUD.showError(error.localizedDescription, interaction: true)
        }
        
    }
    // ------------------------------------------------
    
}
