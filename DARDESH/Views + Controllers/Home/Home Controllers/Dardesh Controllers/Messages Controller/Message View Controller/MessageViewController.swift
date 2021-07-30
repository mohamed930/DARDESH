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
    var ty = ""  // remove it after finishing
    var chatid = ""
    var recipientid = ""
    var recipientName = ""
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
    }
    
    
    // MARK:- TODO:- This Method For Configure the Message Collection View
    func ConfigureMessageCollection() {
        
        messagesCollectionView.messagesDataSource = self
        
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        messagesCollectionView.refreshControl = refreshController
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Methof For Configgure the input bar with two button and relatr textfield with rxswift varible.
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
                
            }
            else {
                
                // Add Send Button To messageInputBar.
                self.messageInputBar.setStackViewItems([self.messageInputBar.sendButton], forStack: .right, animated: false)
                self.messageInputBar.setRightStackViewWidthConstant(to: 40, animated: false)
                
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
            
            print("Realm Directory: \(Realm.Configuration.defaultConfiguration.fileURL!)")
            
            // Clear TextField and Dismiss KeyPad.
            self.messageInputBar.inputTextView.text = ""
            self.messageInputBar.inputTextView.resignFirstResponder()
            
        }).disposed(by: disposebag)
        
    }
}
