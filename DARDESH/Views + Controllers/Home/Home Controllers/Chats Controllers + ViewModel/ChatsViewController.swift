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
    let chatsviewmodel = ChatsViewModel()
    let disposebag = DisposeBag()
    // ------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        ConfigureCell()
        subscribeToResponseTableView()
        GetChatsRoom()
    }
    
    
    // MARK:- TODO:- This Method For Intialise Nib Cell here.
    func ConfigureCell() {
        tableView.delegate = nil
        tableView.dataSource = nil
        
        tableView.register(UINib(nibName: cellNibFileName, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    // ------------------------------------------------
    
    
    
    // MARK:- TODO:- This Method For Subscribe Array to TableView with RxSwift.
    func subscribeToResponseTableView() {
        chatsviewmodel.ChatsModelObservable.asObservable().bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: ChatsCell.self)) { row, branch, cell in
            
            cell.ConfigureCell(branch)
            
        }.disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Getting Data From Firebase.
    func GetChatsRoom() {
        chatsviewmodel.GetDataOperation()
    }
    // ------------------------------------------------
}
