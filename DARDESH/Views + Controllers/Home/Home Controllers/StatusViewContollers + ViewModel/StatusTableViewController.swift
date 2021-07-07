//
//  StatusTableViewController.swift
//  DARDESH
//
//  Created by Mohamed Ali on 07/07/2021.
//

import UIKit
import RxSwift
import RxCocoa

class StatusTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- TODO:- This Sektion for initial varibles.
    let nibfileName    = "StatusCell"
    let cellIdentifier = "Cell"
    let statusviewmodel = StatusViewModel()
    let disposebag = DisposeBag()
    // ------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Choose your status"
        configueNibFile()
        FillTableView()
        GetDataToFill()
    }
    
    // MARK:- TODO:- This Method For Configure nib file to TableView.
    func configueNibFile() {
        tableView.register(UINib(nibName: nibfileName, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Fill Data to tableView.
    func FillTableView() {
        
        statusviewmodel.StatusModelObservable
        .bind(to: tableView
        .rx
        .items(cellIdentifier: cellIdentifier,
               cellType: StatusCell.self)) { row, branch, cell in
               
                cell.StatusLabel.text = branch.statusName
            
        }.disposed(by: disposebag)
        
        
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- Fill Data.
    func GetDataToFill() {
        statusviewmodel.GetData()
    }
    // ------------------------------------------------
    

}
