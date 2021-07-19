//
//  ChatsViewController.swift
//  DARDESH
//
//  Created by Mohamed Ali on 01/07/2021.
//

import UIKit
import RxSwift
import RxCocoa

class ChatsViewController: UITableViewController {
    
    // MARK:- TODO:- This Sektion For intialise New Varibles Here:-
    let cellIdentifier = "Cell"
    let cellNibFileName = "ChatsCell"
    let chatsviewmodel = ChatsViewController()
    let disposebag = DisposeBag()
    // ------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        ConfigureCell()
    }
    
    
    // MARK:- TODO:- This Method For Intialise Nib Cell here.
    func ConfigureCell() {
        tableView.delegate = nil
        tableView.dataSource = nil
        
        tableView.register(UINib(nibName: cellNibFileName, bundle: nil), forHeaderFooterViewReuseIdentifier: cellIdentifier)
    }
    // ------------------------------------------------
}
