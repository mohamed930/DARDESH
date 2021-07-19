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
    let disposebag = DisposeBag()
    // ------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.title = ""
        
        ProfileImageView.MakeImageCircle()
        
        loadData()
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
    
    
    // MARK:- TODO:- make StartChat action with rxswift
    func StartchatsubscribeTap() {
        StartChatButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] (_) in
            
            guard let self = self else { return }
            
            print("Start is here with \(self.SelectedUser.uid)")
            
            
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------

}
