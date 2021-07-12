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
    
    var SelectedUser: UserModel!
    let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "UserProfile".localized
        ProfileImageView.MakeImageCircle()
        loadData()
        StartchatsubscribeTap()
    }
    
    func loadData() {
        print("F: \(SelectedUser.UserName)")
        print("F: \(SelectedUser.status)")
        print("F: \(SelectedUser.Image)")
        
        DispatchQueue.main.async {
            self.ProfileImageView.kf.setImage(with:URL(string: self.SelectedUser.Image))
        }
        UsernameLabel.text   = SelectedUser.UserName
        UserStatusLabel.text = SelectedUser.status
    }
    
    // MARK:- TODO:- make StartChat action with rxswift
    func StartchatsubscribeTap() {
        StartChatButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] (_) in
            
            guard let self = self else { return }
            
            print("Start is here with \(self.SelectedUser.uid)")
            
            
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------

}
