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
    @IBOutlet weak var MessLabel: UILabel!
    @IBOutlet weak var BackView: UIView!
    
    // MARK:- TODO:- Initial New Varibles Here:-
    let nibfileName = "UsersCell"
    let cellIdentifier = "Cell"
    let usersviewmodel = UsersViewModel()
    let disposebag = DisposeBag()
    // ------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AddTapGeuster()
        
//        let attributes = [NSAttributedString.Key.font: UIFont(name: "Signika-Medium", size: 16.0), NSAttributedString.Key.foregroundColor: UIColor.black]
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = attributes as [NSAttributedString.Key : Any]
        
        if #available(iOS 13.0, *) {
            UserSearch[keyPath: \.?.searchTextField]?.font = UIFont(name: "Signika-Medium", size: 18.0)
        } else {
            // Fallback on earlier versions
        }
        
        subscribeSearchTextField()
        subscribeSeachTextFieldEmpty()
        subscribeToSearch()
        
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
    
    // MARK:- TODO:- This Method For Subscribe SearchTextField For his RxVarible.
    func subscribeSearchTextField() {
        UserSearch.rx.text.orEmpty.bind(to: usersviewmodel.SearchTextFieldBehaviour).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Calling Search in ViewModel.
    func subscribeToSearch() {
        usersviewmodel.SearchOperation()
    }
    
    
    // MARK:- TODO:- This Method For Checking if textField is Empty or not.
    func subscribeSeachTextFieldEmpty() {
        
        usersviewmodel.isSearchBehaviour.asObservable().subscribe(onNext: { [weak self] action in
            
            guard let self = self else { return }
            
            if action {
                print("TextField is Empty")
                
                self.usersviewmodel.UsersModelSubject.accept(self.usersviewmodel.BackupUsersModelSubject.value)
                
                self.MessLabel.isHidden = true
                self.tableView.isHidden = false
            }
            else {
                if self.usersviewmodel.UsersModelSubject.value.isEmpty {
                    self.MessLabel.text = "No Users"
                    self.MessLabel.isHidden = false
                    self.tableView.isHidden = true
                }
            }
            
        }).disposed(by: disposebag)
        
    }
    // ------------------------------------------------
    
    
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
        
        usersviewmodel.UsersModelSubject
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
    
    // MARK:- TODO:- This Method if touch any point in main Screen.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method for Adding Tap Guester into the view in tableView.
    func AddTapGeuster() {
        let tab = UITapGestureRecognizer(target: self, action: #selector(DismissKeyPad(tapGestureRecognizer:)))
        tab.numberOfTapsRequired = 1
        tab.numberOfTouchesRequired = 1
        BackView.isUserInteractionEnabled = true
        BackView.addGestureRecognizer(tab)
    }
    
    @objc func DismissKeyPad(tapGestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    // ------------------------------------------------

}
