//
//  Incomming.swift
//  DARDESH
//
//  Created by Mohamed Ali on 30/07/2021.
//

import Foundation
import RealmSwift
import MessageKit

class Incomming {
    
    // MARK:- TODO:- initialise new varibels here.
    var messageViewController: MessageViewController
    // ------------------------------------------------
    
    // MARK:- TODO:- initial the messageviewcontroller.
    init(messageViewController: MessageViewController) {
        self.messageViewController = messageViewController
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method Convert Message Model to MKMessage to use in message kit.
    func createMCMessage (localMessage: MessageModel) -> MKMessage {
        
        return MKMessage(message: localMessage)
        
    }
    
}
