//
//  EditProfileViewController.swift
//  DARDESH
//
//  Created by Mohamed Ali on 04/07/2021.
//

import UIKit
import RxSwift
import RxCocoa
import ProgressHUD

class EditProfileViewController: UITableViewController {
    
    @IBOutlet weak var ProfileImageView: UIImageView!
    
    @IBOutlet weak var UserNameTextField: UITextField!
    
    @IBOutlet weak var StatusLabel: UILabel!
    
    @IBOutlet weak var cell: UITableViewCell!
    
    @IBOutlet weak var EditButton: UIButton!
    
    let editviewmodel = EditProfileViewModel()
    let disposebag    = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ProfileImageView.MakeImageCircle()
        subscribeToUserName()
        subsctibeToResponseUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        subscribeisLoading()
        SubscribeToResponse()
        editviewmodel.loadUserDataOperation()
    }
    
    // MARK:- TODO:- This Mehtod for Binding TextField with rxSwift varible.
    func subscribeToUserName() {
        UserNameTextField.rx.text.orEmpty.bind(to: editviewmodel.UserNameBehaviour).disposed(by: disposebag)
    }
    
    // MARK:- TODO:- This Method For responseLoading.
    func subscribeisLoading() {
        editviewmodel.isloadingBehaviour.subscribe(onNext: { isload in
            
            if isload {
                self.showAnimation()
            }
            else {
                self.stopAnimating()
            }
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For print data from UserDefault Response.
    func SubscribeToResponse() {
        
        editviewmodel.CollectDataModelSubjectObserval.subscribe(onNext: { [weak self] userData in
            
            guard let self = self else { return }
            
            self.UserNameTextField.text = userData.UserName
            self.StatusLabel.text  = userData.status
            
            DispatchQueue.main.async {
                self.ProfileImageView.kf.setImage(with:URL(string: userData.Image))
            }
            
        }).disposed(by: disposebag)
        
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- Get Reponse from update data.
    func subsctibeToResponseUpdate() {
        
        editviewmodel.UpdateResponseModelSubjectObserval.subscribe(onNext: { res in
            
            if res {
                ProgressHUD.showSuccess("UserNameAction".localized, interaction: true)
            }
            else {
                ProgressHUD.showError("UserNameActionFalse".localized, interaction: true)
            }
            
        }).disposed(by: disposebag)
        
    }
    // ------------------------------------------------
    
    
    @IBAction func SettingTapped(_ sender: Any) {
        self.dismissDetail()
    }
    
    @IBAction func TapGeusterTapped (_ sender: Any) {
        self.view.endEditing(true)
    }
    
}
