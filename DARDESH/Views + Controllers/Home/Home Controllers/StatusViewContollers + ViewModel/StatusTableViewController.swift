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
    var checkMarkStatus = String()
    // ------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Choose your status"
        configueNibFile()
        subscribeToResponse()
        bindStatusValue()
        GetDataToFill()
        subscribeisLoading()
        subscribeToStatusSelection()
    }
    
    // MARK:- TODO:- Bind Varible to rxSwift varible.
    func bindStatusValue() {
        statusviewmodel.checkmarksStatus.accept(checkMarkStatus)
        
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Configure nib file to TableView.
    func configueNibFile() {
        tableView.register(UINib(nibName: nibfileName, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Fill Data to tableView.
    func subscribeToResponse() {
        
        statusviewmodel.StatusModelObservable
        .bind(to: tableView
        .rx
        .items(cellIdentifier: cellIdentifier,
               cellType: StatusCell.self)) { row, branch, cell in
               
                cell.StatusLabel.text = branch.statusName
            
                if branch.checkMark {
                    cell.accessoryType = .checkmark
                }
                else {
                    cell.accessoryType = .none
                }
            
        }.disposed(by: disposebag)
        
        
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- Fill Data.
    func GetDataToFill() {
        statusviewmodel.GetData()
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For responseLoading.
    func subscribeisLoading() {
        statusviewmodel.isloading.subscribe(onNext: { isload in
            
            if isload {
                self.showAnimation()
            }
            else {
                self.stopAnimating()
            }
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Checking Status Cell.
    func subscribeToStatusSelection() {
        
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(StatusModel.self))
            .bind { [weak self] selectedIndex, branch in

                guard let self = self else { return }
                
                if branch.checkMark == false {
                    
                    // Change Value to true
                    var B = branch
                    B.checkMark = true
                    
                    // Add Check Marks on current cell
                    let cell = self.tableView.cellForRow(at: selectedIndex) as? StatusCell
                    cell?.accessoryType = .checkmark
//                    cell?.accessoryType = B.checkMark ? .checkmark : .none
                    
                    // Send Values to rxswift Varibles to Update.
                    self.statusviewmodel.CurrentItemChangedIndexBehaviour.accept(selectedIndex[1])
                    self.statusviewmodel.CurrentItemChangedStatusBehaviour.accept(B.checkMark)
                    self.statusviewmodel.StatusNameBehaviour.accept(branch.statusName)
                    
                    // Updata Data on Firebase & UserDefaults
                    self.statusviewmodel.UpdateOperation()

                    print(selectedIndex[1], B.checkMark)
                }
        }
        .disposed(by: disposebag)
        
    }
    // ------------------------------------------------
    

}
