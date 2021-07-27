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
    
    init(chatid: String , recipientid: String , recipientName: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.chatid = chatid
        self.recipientid = recipientid
        self.recipientName = recipientName
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
}
