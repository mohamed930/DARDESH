//
//  UsersViewController.swift
//  DARDESH
//
//  Created by Mohamed Ali on 10/07/2021.
//

import UIKit
import RxSwift
import RxCocoa

class UsersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var UserSearch: UISearchBar!
    
    // MARK:- TODO:- Initial New Varibles Here:-
    let nibfileName = "UsersCell"
    let cellIdentifier = "Cell"
    let usersviewmodel = UsersViewModel()
    let disposebag = DisposeBag()
    // ------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configueNibFile()
        subscribeisLoading()
        SubscribeToResponseUsersData()
        GetAllData()
        SubscribeToChooceTheCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK:- TODO:- This Method For Configure nib file to TableView.
    func configueNibFile() {
        tableView.register(UINib(nibName: nibfileName, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For responseLoading.
    func subscribeisLoading() {
        usersviewmodel.isLoadingBehaviour.subscribe(onNext: { isload in
            
            if isload {
                self.showAnimation()
            }
            else {
                self.stopAnimating()
            }
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Getten Response From Firebase.
    func SubscribeToResponseUsersData() {
        
        usersviewmodel.UsersModelObservable
        .bind(to: tableView
        .rx
        .items(cellIdentifier: cellIdentifier,
               cellType: UsersCell.self)) { row, branch, cell in
               
               cell.ConfigureCell(User: branch)
            
        }.disposed(by: disposebag)
        
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Call Firebase To Get All Users From DataBase.
    func GetAllData() {
        usersviewmodel.GetAllUsersOperation()
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Going to The UserDetails To Start A Chat.
    func SubscribeToChooceTheCell () {
        
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(UserModel.self))
            .bind { [weak self] selectedIndex, branch in

                guard let self = self else { return }
                
                let next = self.storyboard?.instantiateViewController(withIdentifier: "ProfileUserTableViewController") as! ProfileUserTableViewController
                
                next.SelectedUser = branch
                
                self.navigationController?.pushViewController(next, animated: true)
                
                print(selectedIndex[1], branch.UserName)
        }
        .disposed(by: disposebag)
        
    }
    // ------------------------------------------------

}
