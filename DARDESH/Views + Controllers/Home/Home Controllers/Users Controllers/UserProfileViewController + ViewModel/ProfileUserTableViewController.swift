//
//  ProfileUserTableViewController.swift
//  DARDESH
//
//  Created by Mohamed Ali on 10/07/2021.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class ProfileUserTableViewController: UITableViewController {
    
    @IBOutlet weak var ProfileImageView: UIImageView!
    @IBOutlet weak var UsernameLabel: UILabel!
    @IBOutlet weak var UserStatusLabel: UILabel!
    @IBOutlet weak var StartChatButton: UIButton!
    
    // MARK:- TODO:- This Sektion for intialise new varibles
    var SelectedUser: UserModel!
    let profileuserviewmodel = ProfileUserViewModel()
    let disposebag = DisposeBag()
    // ------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.title = ""
        
        ProfileImageView.MakeImageCircle()
        
        loadData()
        SubscribeToReponse()
        StartchatsubscribeTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.largeTitleDisplayMode = .always
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.sizeToFit()
        
        self.navigationItem.title = SelectedUser.UserName
        
    }
    
    // MARK:- TODO:- This Method For Download Data after Picking from Users VC.
    func loadData() {
        
        DispatchQueue.main.async {
            self.ProfileImageView.kf.setImage(with:URL(string: self.SelectedUser.Image))
        }
        UsernameLabel.text   = SelectedUser.UserName
        UserStatusLabel.text = SelectedUser.status
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Subscribe Response of Success Writing Chat.
    func SubscribeToReponse() {
        profileuserviewmodel.ResponseData.subscribe(onNext: { response in
            
            if response == "Success" {
                print("Created Room is Success")
                // Go To To The Chat View
                
            }
            else if response == "Failed" {
                print("Created Room is Failed")
            }
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- make StartChat action with rxswift
    func StartchatsubscribeTap() {
        StartChatButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] (_) in
            
            guard let self = self else { return }
            
            print("Start is here with \(self.SelectedUser.uid)")
            
            guard let senderUser = self.profileuserviewmodel.GetUserData() else { return }
            
            self.profileuserviewmodel.StartChat(sender: senderUser, Receiver: self.SelectedUser)
            
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------

}
