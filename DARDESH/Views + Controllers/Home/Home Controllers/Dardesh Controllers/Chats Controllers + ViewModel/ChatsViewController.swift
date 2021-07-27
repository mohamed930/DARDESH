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
    
    @IBOutlet weak var NewChatButton: UIBarButtonItem!
    
    // MARK:- TODO:- This Sektion For intialise New Varibles Here:-
    let cellIdentifier = "Cell"
    let cellNibFileName = "ChatsCell"
    let chatsviewmodel = ChatsViewModel()
    let profileuserviewmodel = ProfileUserViewModel()
    let disposebag = DisposeBag()
    let searchController = UISearchController(searchResultsController: nil)
    // ------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        ConfigureChatsSearchBar()
        subscribeSeachTextFieldEmpty()
        subscribeToSearch()
        
        ConfigureCell()
        subscribeToResponseTableView()
        subscribeToResponseDeleteTableView()
        SubscribeToTappedCell()
        GetChatsRoom()
        
        subscribeToButtonAction()
    }
    
    // MARK:- TODO:- This method For Configure the searchBar Controller.
    func ConfigureChatsSearchBar() {
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "ChatSearchPlaceHolder".localized
        
        definesPresentationContext = true
        BindToSearchBar()
        
//        searchController.searchResultsUpdater = self
//        refreshControl = UIRefreshControl()
//        tableView.refreshControl = refreshControl
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Methof for Binding SearchBar to  rxSwift.
    func BindToSearchBar() {
        searchController.searchBar.rx.text.orEmpty.bind(to: chatsviewmodel.TextFieldBehaviour).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    
    
    // MARK:- TODO:- This Method For Checking if textField is Empty or not.
    func subscribeSeachTextFieldEmpty() {
        
        chatsviewmodel.isSearchBehaviour.asObservable().subscribe(onNext: { [weak self] action in
            
            guard let self = self else { return }
            
            if action {
                print("TextField is Empty")
                
                self.chatsviewmodel.ChatsModelSubject.accept(self.chatsviewmodel.BackupChatsModelSubject.value)
            }
            
        }).disposed(by: disposebag)
        
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Calling Search in ViewModel.
    func subscribeToSearch() {
        chatsviewmodel.SearchOperation()
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Intialise Nib Cell here.
    func ConfigureCell() {
        tableView.delegate = nil
        tableView.dataSource = nil
        
        tableView.register(UINib(nibName: cellNibFileName, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    // ------------------------------------------------
    
    
    
    // MARK:- TODO:- This Method For Subscribe Array to TableView with RxSwift.
    func subscribeToResponseTableView() {
        chatsviewmodel.ChatsModelSubject
            .asObservable()
            .bind(to: tableView
                                .rx
                                .items(cellIdentifier: cellIdentifier, cellType: ChatsCell.self)) { row, branch, cell in
            
                                        cell.ConfigureCell(branch)
            
        }.disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    
    
    // MARK:- TODO:- This Method For subscribe Delete in tableView.
    func subscribeToResponseDeleteTableView() {
        
        tableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexpath in
                
                guard let self = self else { return }
                
                let alert = UIAlertController(title: "Attention".localized , message: "DeleMess".localized , preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
                
                alert.addAction(UIAlertAction(title: "Delete".localized, style: .destructive, handler: { [weak self] _ in
                    
                    guard let self = self else { return }
                    
                    self.chatsviewmodel.DeleteOperation(at: indexpath)
                    
                }))
                
                self.present(alert, animated: true)
                
            })
            .disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Selection Cell.
    func SubscribeToTappedCell() {
        
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(ChatModel.self))
            .bind { [weak self] selectedIndex, branch in

                guard let self = self else { return }
                
                guard let senderData = self.profileuserviewmodel.GetUserData() else { return }
                
                self.chatsviewmodel.GetReceverData(UsersId: branch.membersId) { usermodel in
                    
                    print("ChatRoomId: \(branch.chatRoomId), SenderName: \(senderData.uid), RecevierName: \(usermodel.first?.uid ?? "Boo")")
                    
                    self.profileuserviewmodel.RestartChat(chatRoomId: branch.chatRoomId, sender: senderData, Receiver: usermodel.first!)
                    
                    let privateMsg = MessageViewController(chatid: branch.chatRoomId , recipientid: branch.RecevierID , recipientName: branch.RecevierName)
                    
                    self.navigationController?.pushViewController(privateMsg, animated: true)
                    
                    print(selectedIndex[1], branch.RecevierName)
                }
        }
        .disposed(by: disposebag)
        
    }
    // ------------------------------------------------
    
    
    
    // MARK:- TODO:- This Method For Getting Data From Firebase.
    func GetChatsRoom() {
        chatsviewmodel.GetDataOperation()
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Button Action with RxSwift.
    func subscribeToButtonAction() {
        
        NewChatButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] (_) in
            
            guard let self = self else { return }
            
            let storyBoard = UIStoryboard(name: "HomeView", bundle: nil)
            
            let next = storyBoard.instantiateViewController(withIdentifier: "ChatUsersTableViewController") as! ChatUsersTableViewController
            
            self.navigationController?.pushViewController(next, animated: true)
            
        }).disposed(by: disposebag)
        
    }
    // ------------------------------------------------
}
