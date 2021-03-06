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
import Gallery

class EditProfileViewController: UITableViewController {
    
    @IBOutlet weak var ProfileImageView: UIImageView!
    @IBOutlet weak var UserNameTextField: UITextField!
    @IBOutlet weak var StatusLabel: UILabel!
    @IBOutlet weak var cell: UITableViewCell!
    @IBOutlet weak var EditButton: UIButton!
    @IBOutlet weak var StatusCell: UIView!
    
    // MARK:- TODO:- This for initalise new varible.
    var screenedge : UIScreenEdgePanGestureRecognizer!
    let editviewmodel = EditProfileViewModel()
    let disposebag    = DisposeBag()
    // ------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initScreenEdgeGeuster()
        AddTapGeusterToTableView()
        AddTapGeusterToStatusCell()
        ProfileImageView.MakeImageCircle()
        subscribeToUserName()
        subsctibeToResponseUpdate()
        subscribeToEdit()
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
            self.StatusLabel.text  = userData.status.localized
            
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
    
    // MARK:- TODO:- This Method For EditAction To Open Gallary and Change Profile Image.
    func subscribeToEdit() {
        
        EditButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] (_) in
            
            guard let self = self else { return }
            
            // Open Gallary.
            self.OpenGalleyWithConfig(VC: self, initTap: .imageTab, numberOfImages: 1, tapsType: [.imageTab,.cameraTab])
            
        }).disposed(by: disposebag)
        
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method for Adding TapGeuster to tableView.
    func AddTapGeusterToTableView() {
        
        let tab = UITapGestureRecognizer(target: self, action: #selector(DismissKeyPad(tapGestureRecognizer:)))
        tab.numberOfTapsRequired = 1
        tab.numberOfTouchesRequired = 1
        tableView.isUserInteractionEnabled = true
        tableView.addGestureRecognizer(tab)
        
    }
    
    @objc func DismissKeyPad(tapGestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This method for going to Status TableView.
    func AddTapGeusterToStatusCell() {
        let tab = UITapGestureRecognizer(target: self, action: #selector(GotoStatus(tapGestureRecognizer:)))
        tab.numberOfTapsRequired = 1
        tab.numberOfTouchesRequired = 1
        StatusCell.isUserInteractionEnabled = true
        StatusCell.addGestureRecognizer(tab)
    }
    
    @objc func GotoStatus(tapGestureRecognizer: UITapGestureRecognizer) {
        
        let next = storyboard?.instantiateViewController(withIdentifier: "StatusTableViewController") as! StatusTableViewController
        
        next.checkMarkStatus = StatusLabel.text!
        
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Setting Tapped to Dismiss.
    @IBAction func SettingTapped(_ sender: Any) {
        "lang".localized == "eng" ? self.dismissDetailEn() : self.dismissDetailAr()
    }
    // ------------------------------------------------
    
    
    
    // MARK:- TODO:- Add ScreenEdgePanGesture To This Page.
    func initScreenEdgeGeuster() {
        screenedge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(Back(_:)))
        
        if "lang".localized == "eng" {
            screenedge.edges = .left
        }
        else {
            screenedge.edges = .right
        }
        
        view.addGestureRecognizer(screenedge)
    }
    
    @objc func Back (_ sender:UIScreenEdgePanGestureRecognizer) {
        "lang".localized == "eng" ? self.dismissDetailEn() : self.dismissDetailAr()
    }
    // ------------------------------------------------
}
