//
//  MessageViewController.swift
//  DARDESH
//
//  Created by Mohamed Ali on 26/07/2021.
//

import UIKit
import MessageKit
import RealmSwift
import InputBarAccessoryView
import Gallery
import RxSwift
import RxCocoa

class MessageViewController: MessagesViewController {
    
    // MARK:- TODO:- intialise new varibles here
    var screenedge : UIScreenEdgePanGestureRecognizer!
    let subtitle: UILabel = {
        let title = "lang".localized == "eng" ? UILabel(frame: CGRect(x: 5, y: 20, width: 100, height: 25)) : UILabel(frame: CGRect(x: 95, y: 20, width: 100, height: 25))
        title.textAlignment = "lang".localized == "eng" ? .left : .right
        title.font = UIFont.systemFont(ofSize: 14,weight: .medium)
        title.textColor = .darkGray
        title.adjustsFontSizeToFitWidth = true
        return title
    }()
    var ty = ""  // remove it after finishing
    var chatid = ""
    var recipientid = ""
    var recipientName = ""
    var typing = true
    var refreshController = UIRefreshControl()
    var AttachButton = InputBarButtonItem()
    var MicButton = InputBarButtonItem()
    let messageviewmodel = MessageViewModel()
    var currentUserSender: MKSender!
    let disposebag = DisposeBag()
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This init for init message view controller.
    init(chatid: String , recipientid: String , recipientName: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.chatid = chatid
        self.recipientid = recipientid
        self.recipientName = recipientName
        
        self.currentUserSender = MKSender(senderId: messageviewmodel.GetCurrentUserData().uid , displayName: messageviewmodel.GetCurrentUserData().UserName)
        
        self.messageviewmodel.ChatIdBahaviour.accept(chatid)
        self.messageviewmodel.recipientidBahaviour.accept(recipientid)
        self.messageviewmodel.recipientNameBahaviour.accept(recipientName)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    // ------------------------------------------------

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConfigureMessageCollection()
        ConfigureInputBar()
        
        SubscribeToAttachButtonAction()
        SubscribeToSendButtonAction()
        
        
        SubscribeisTyping()
        CheckisTyping()
        
        SubscribeToReponse()
        GetMessages()
        
        
        subscribeToResponseReaded()
        
    }
    
    
    // MARK:- TODO:- I used method to call init the naviagation Bar.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ConfigureNavigationBar()
        initScreenEdgeGeuster()
    }
    // ------------------------------------------------
    
    
    
    
    // MARK:- TODO:- This Method For Customize Navigation Bar.
    func ConfigureNavigationBar() {
        
        self.navigationItem.largeTitleDisplayMode = .never
        
        let leftBarButtonView: UIView =  {
            return UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        }()
        
        let titleLabel: UILabel = {
            let title = "lang".localized == "eng" ? UILabel(frame: CGRect(x: 5, y: 0, width: 100, height: 25)) : UILabel(frame: CGRect(x: 95, y: 0, width: 100, height: 25))
            title.textAlignment = "lang".localized == "eng" ? .left : .right
            title.font = UIFont.systemFont(ofSize: 16,weight: .medium)
            title.adjustsFontSizeToFitWidth = true
            return title
        }()
        
        
        if "lang".localized == "eng" {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "NextAr"), style: .plain, target: self, action: #selector(self.BackButtonPressed))
        }
        else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "next-1"), style: .plain, target: self, action: #selector(self.BackButtonPressed))
        }
        
        titleLabel.text = recipientName
        
        leftBarButtonView.addSubview(titleLabel)
        leftBarButtonView.addSubview(subtitle)
        
        let leftBarButtonItem = UIBarButtonItem(customView: leftBarButtonView)
        
        self.navigationItem.leftBarButtonItems?.append(leftBarButtonItem)
        
        
        
    }
    
    @objc func BackButtonPressed() {
        BackOperation()
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- Add ScreenEdgePanGesture To This Page.
    func initScreenEdgeGeuster() {
        screenedge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(Back(_:)))
        
        if "lang".localized == "eng" {
            screenedge.edges = .left
        }
        else {
            screenedge.edges = .right
        }
        
        view.addGestureRecognizer(screenedge)
    }
    
    @objc func Back (_ sender:UIScreenEdgePanGestureRecognizer) {
        BackOperation()
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Private method For Back Operation.
    private func BackOperation() {
        
        // Update ChatRoom Methods.
        messageviewmodel.UpdateCounterUsingIdOperatoin()
        
        // remove Listenr.
        messageviewmodel.ReomoveAllLestnerOperation()
        
        self.navigationController?.popViewController(animated: true)
        
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Configure the Message Collection View
    func ConfigureMessageCollection() {
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        self.messagesCollectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 10)
        
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        messagesCollectionView.refreshControl = refreshController
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Methof For Configgure the input bar with two button and relate textfield with rxswift varible.
    func ConfigureInputBar() {
        
        // Configure The Attach Button
        if #available(iOS 13.0, *) {
            AttachButton.image = UIImage(named: "84281", in: nil , with: UIImage.SymbolConfiguration(pointSize: 30))
        } else {
            // Fallback on earlier versions
            AttachButton.image = UIImage(named: "84281")
        }
        AttachButton.setSize(CGSize(width: 30.0, height: 30.0), animated: false)
        
        // Configure The Mic Button
        if #available(iOS 13.0, *) {
            MicButton.image = UIImage(named: "mic", in: nil , with: UIImage.SymbolConfiguration(pointSize: 30))
        } else {
            // Fallback on earlier versions
            MicButton.image = UIImage(named: "mic")
        }
        
        MicButton.setSize(CGSize(width: 30.0, height: 30.0), animated: false)
        
        // Add Attach Button to input bar.
        messageInputBar.setStackViewItems([AttachButton], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 30, animated: false)
        
        messageInputBar.inputTextView.isImagePasteEnabled = false
        
        // relate the textfield to it's rxswift and check it if it's empty or not
        SubscribeToTextField()
        SubscribeToTextFieldisEmpty()
        
        
        // make it color.
        if #available(iOS 13.0, *) {
            messageInputBar.backgroundView.backgroundColor = .systemBackground
            messageInputBar.inputTextView.backgroundColor = .systemBackground
        }
        
        
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Action for AttachButton.
    func SubscribeToAttachButtonAction() {
        AttachButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            
            guard let self = self else { return }
            
            print("Attacehd Document Tapped")
            self.ty = ""
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    
    
    // MARK:- TODO:- This Method For Binding MessageTextFeild with RxSwift Varible.
    func SubscribeToTextField() {
        messageInputBar.inputTextView.rx.text.orEmpty.bind(to: messageviewmodel.inputTextFieldBahaviour).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    
    
    // MARK:- TODO:- This Method For Check if textField is empty or not to show mic button or not.
    func SubscribeToTextFieldisEmpty() {
        messageviewmodel.isinputTextFieldEmpty.subscribe(onNext: { [weak self] empty in
            
            guard let self = self else { return }
            
            if empty {
                
                // Add Mic Button To messageInputBar.
                self.messageInputBar.setStackViewItems([self.MicButton], forStack: .right, animated: false)
                self.messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
                self.typing = true
                
            }
            else {
                
                // Add Send Button To messageInputBar.
                self.messageInputBar.setStackViewItems([self.messageInputBar.sendButton], forStack: .right, animated: false)
                self.messageInputBar.setRightStackViewWidthConstant(to: 40, animated: false)
                
                self.messageviewmodel.startTypingIdecatorOperation()
                
                if self.typing == true {
                    self.messagesCollectionView.scrollToLastItem(animated: false)
                    self.messagesCollectionView.scrollToBottom(animated: false)
                    self.typing = false
                }
                
                
            }
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    
    
    // MARK:- TODO:- This Action Method For Send Button.
    func SubscribeToSendButtonAction() {
        
        messageInputBar.sendButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            
            guard let self = self else { return }
            
            // Send A Message
            self.messageviewmodel.sendMessageTextOperation()
            
            // Send to realmswift listner that an update is a new message to handle it.
            self.messageviewmodel.responseReadedBehaviour.accept(false)
            
            // For Reading New messages for empty arr.
            if self.messageviewmodel.MessagesBahaviour.value.count == 0 {
                self.messageviewmodel.loadMessageOperation(messageViewContrller: self)
            }
            
//            print("Realm Directory: \(Realm.Configuration.defaultConfiguration.fileURL!)")
            
            // Clear TextField and Dismiss KeyPad.
            self.messageInputBar.inputTextView.text = ""
            self.messageInputBar.inputTextView.resignFirstResponder()
            self.messagesCollectionView.scrollToLastItem()
            
        }).disposed(by: disposebag)
        
    }
    // ------------------------------------------------
    
    
    
    // MARK:- TODO:- This Method For Listen for Read Status and change it in the tableView.
    func ListenisReadedStatus() {
        messageviewmodel.ListenToReadMessOperation()
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Checking if you are typing or not.
    func SubscribeisTyping() {
        
        messageviewmodel.isTypingBehaviour.subscribe(onNext: { [weak self] typing in
            
            guard let self = self else { return }
            
            if typing {
                self.subtitle.text = "typing..."
            }
            else {
                self.subtitle.text = ""
            }
            
        }).disposed(by: disposebag)
        
    }
    
    // MARK:- TODO:- This Method For Checking another user is Typing or not.
    func CheckisTyping () {
        messageviewmodel.isTypingLestner()
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Response To Getten Messages.
    func SubscribeToReponse() {
        messageviewmodel.responseBehaviour.subscribe(onNext: { [weak self] response in
            
            guard let self = self else { return }
            
            if response {
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem(animated: false)
                self.messagesCollectionView.scrollToBottom(animated: false)
            }
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    
    
    // MARK:- TODO:- This Method For Listen any changes of read status to reload data.
    func subscribeToResponseReaded() {
        messageviewmodel.responseReaded1Behaviour.subscribe(onNext: { response in
            if response {
                self.messagesCollectionView.reloadData()
            }
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    

    
    // MARK:- TODO:- This Method For Getting Messages.
    func GetMessages() {
        messageviewmodel.loadMessageOperation(messageViewContrller: self)
        messageviewmodel.ReadNewMessagesOpertation()
        ListenisReadedStatus()
        
    }
    // ------------------------------------------------
}
