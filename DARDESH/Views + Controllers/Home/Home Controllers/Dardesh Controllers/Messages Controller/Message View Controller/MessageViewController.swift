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
        self.currentUserSender = MKSender(senderId: currentUser, displayName: messageviewmodel.GetCurrentUserData().UserName)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    // ------------------------------------------------

    
    override func viewDidLoad() {
        super.viewDidLoad()

        messagesCollectionView.messagesDataSource = self
        
        ConfigureMessageCollection()
        ConfigureInputBar()
        SubscribeToAttachButtonAction()
    }
    
    
    func ConfigureMessageCollection() {
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        messagesCollectionView.refreshControl = refreshController
    }
    
    
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
        
        messageInputBar.setStackViewItems([AttachButton], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 30, animated: false)
        
        messageInputBar.inputTextView.isImagePasteEnabled = false
        
        SubscribeToTextField()
        SubscribeToTextFieldisEmpty()
        
        
        if #available(iOS 13.0, *) {
            messageInputBar.backgroundView.backgroundColor = .systemBackground
            messageInputBar.inputTextView.backgroundColor = .systemBackground
        }
        
        
    }
    
    func SubscribeToAttachButtonAction() {
        AttachButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            
            guard let self = self else { return }
            
            print("Attacehd Document Tapped")
            self.chatid = ""
            
        }).disposed(by: disposebag)
    }
    
    
    func SubscribeToTextField() {
        messageInputBar.inputTextView.rx.text.orEmpty.bind(to: messageviewmodel.inputTextFieldBahaviour).disposed(by: disposebag)
    }
    
    func SubscribeToTextFieldisEmpty() {
        messageviewmodel.isinputTextFieldEmpty.subscribe(onNext: { [weak self] empty in
            
            guard let self = self else { return }
            
            if empty {
                self.messageInputBar.setStackViewItems([self.MicButton], forStack: .right, animated: false)
                self.messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
            }
            else {
                self.messageInputBar.setStackViewItems([self.messageInputBar.sendButton], forStack: .right, animated: false)
                self.messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
            }
            
        }).disposed(by: disposebag)
    }
}
