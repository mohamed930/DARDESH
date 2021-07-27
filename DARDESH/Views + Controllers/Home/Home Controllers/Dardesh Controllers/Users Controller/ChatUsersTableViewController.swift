//
//  ChatUsersTableViewController.swift
//  DARDESH
//
//  Created by Mohamed Ali on 26/07/2021.
//

import UIKit
import RxSwift
import RxCocoa

class ChatUsersTableViewController: UITableViewController {
    
    @IBOutlet weak var BackView: UIView!
    
    // MARK:- TODO:- Initial New Varibles Here:-
    let nibfileName = "UsersCell"
    let cellIdentifier = "Cell"
    let usersviewmodel = UsersViewModel()
    let disposebag = DisposeBag()
    let searchController = UISearchController(searchResultsController: nil)
    // ------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AddTapGeuster()
        
        ConfigureChatsSearchBar()
        subscribeSearchTextField()
        subscribeToSearch()
        subscribeSeachTextFieldEmpty()
        
        configueNibFile()
        subscribeisLoading()
        SubscribeToResponseUsersData()
        GetAllData()
        
        SubscribeToChooceTheCell()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.largeTitleDisplayMode = .never
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.sizeToFit()
        
        self.navigationItem.title = "Users".localized
        self.navigationController?.navigationBar.backItem?.title = "Back".localized
        
    }
    
    
    // MARK:- TODO:- This method For Configure the searchBar Controller.
    func ConfigureChatsSearchBar() {
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "UserSearchPlaceHolder".localized
        
        definesPresentationContext = true
        subscribeSearchTextField()
        
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Subscribe SearchTextField For his RxVarible.
    func subscribeSearchTextField() {
        searchController.searchBar.rx.text.orEmpty.bind(to: usersviewmodel.SearchTextFieldBehaviour).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Calling Search in ViewModel.
    func subscribeToSearch() {
        usersviewmodel.SearchOperation()
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Checking if textField is Empty or not.
    func subscribeSeachTextFieldEmpty() {
        
        usersviewmodel.isSearchBehaviour.asObservable().subscribe(onNext: { [weak self] action in
            
            guard let self = self else { return }
            
            if action {
                print("TextField is Empty")
                self.usersviewmodel.UsersModelSubject.accept(self.usersviewmodel.BackupUsersModelSubject.value)
            }
            
        }).disposed(by: disposebag)
        
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Configure nib file to TableView.
    func configueNibFile() {
        
        tableView.delegate = nil
        tableView.dataSource = nil
        
        self.refreshControl = UIRefreshControl()
        
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl!.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl!)
        
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
    
    
    // MARK:- TODO:- This Method For Refresh TableView.
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        if refreshControl!.isRefreshing {
            self.usersviewmodel.GetAllUsersOperation()
            refreshControl!.endRefreshing()
        }

    }
    // ------------------------------------------------

}
