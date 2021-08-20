//
//  MessageScrollDelegate.swift
//  DARDESH
//
//  Created by Mohamed Ali on 10/08/2021.
//

import UIKit

extension MessageViewController {
    
    // MARK:- TODO:- This Method For Adding Action to refreshController scroll view to load 12 more messages.
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if refreshController.isRefreshing {
            
            if messageviewmodel.displayNumber < messageviewmodel.alllocalMessgaes {
                messageviewmodel.insertMoreMessagesOperation(messageViewContrller: self)
                messagesCollectionView.reloadDataAndKeepOffset()
            }
            
        }
        
        refreshController.endRefreshing()
    }
    // ------------------------------------------------
    
}
