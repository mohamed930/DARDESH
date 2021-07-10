//
//  ProfileUserTableViewController.swift
//  DARDESH
//
//  Created by Mohamed Ali on 10/07/2021.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileUserTableViewController: UITableViewController {
    
    var SelectedUser: UserModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    func loadData() {
        print("F: \(SelectedUser.UserName)")
        print("F: \(SelectedUser.status)")
        print("F: \(SelectedUser.Image)")
    }

}
