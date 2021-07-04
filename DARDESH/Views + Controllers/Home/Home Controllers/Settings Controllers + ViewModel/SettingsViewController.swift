//
//  SettingsViewController.swift
//  DARDESH
//
//  Created by Mohamed Ali on 01/07/2021.
//

import UIKit
import ProgressHUD
import RxSwift
import RxCocoa

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var ProfileCoverImageView: UIImageView!
    @IBOutlet weak var ProfileNameLabel: UILabel!
    @IBOutlet weak var UserStatusLabel: UILabel!
    @IBOutlet weak var ProfileView: UIView!
    
    @IBOutlet weak var TalkFriendButton: UIButton!
    @IBOutlet weak var TermsConditionButton: UIButton!
    
    @IBOutlet weak var AppVersionLabel: UIButton!
    @IBOutlet weak var LogoutButton: UIButton!
    
    // MARK:- TODO:- initial Varibles here:-
    let settingviewmodel = SettingsViewModel()
    let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ProfileCoverImageView.MakeImageCircle()
        
        subscribeToLoading()
        subscribeLogoutResponse()
        subscribeLogoutTapped()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        SubscribeToResponse()
        settingviewmodel.loadUserDataOperation()
    }
    
    // MARK:- TODO:- This Method For print data from UserDefault Response.
    func SubscribeToResponse() {
        
        settingviewmodel.CollectDataModelSubjectObserval.subscribe(onNext: { [weak self] userData in
            
            guard let self = self else { return }
            
            self.ProfileNameLabel.text = userData.UserName
            self.UserStatusLabel.text  = userData.status
            self.AppVersionLabel.setTitle("Application Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")", for: .normal)
            
            DispatchQueue.main.async {
                self.ProfileCoverImageView.kf.setImage(with:URL(string: userData.Image))
            }
            
        }).disposed(by: disposebag)
        
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- work with loading if value is true load or stop
    func subscribeToLoading() {
        settingviewmodel.isloading.subscribe(onNext: { isloading in
            if isloading {
                self.showAnimation()
            }
            else {
                self.stopAnimating()
            }
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This method for getting reponse from logout and take action.
    func subscribeLogoutResponse() {
        settingviewmodel.isSignoutModelSubjectObserval.subscribe(onNext: { [weak self] loggedout in
            
            guard let self = self else { return }
            
            if loggedout {
                
                let story = UIStoryboard(name: "LoginMain", bundle: nil)
                let next  = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                
                next.modalPresentationStyle = .fullScreen
                self.present(next, animated: true, completion: nil)
                
            }
            else {
                ProgressHUD.showError("logoutMess".localized)
            }
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method for making action for button logout with rxswift.
    func subscribeLogoutTapped() {
        
        LogoutButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { (_) in
            
            // Show Alert ask user if he sure to logout or not. before logout operation
            let alert = UIAlertController(title: "logoutTitle".localized, message: "logoutBody".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel".localized , style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "logoutTitle".localized, style: .destructive, handler: { [weak self] alert in
                
                guard let self = self else { return }
                
                // make logout with viewmodel
                self.settingviewmodel.logoutOperation()
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }).disposed(by: disposebag)
        
    }
    // ------------------------------------------------
}
