//
//  ExtensionEditProfileViewController.swift
//  DARDESH
//
//  Created by Mohamed Ali on 04/07/2021.
//

import UIKit

extension EditProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        // Update name into firebase.
        editviewmodel.UpdateUserName()
        return true
    }
    
}

extension EditProfileViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 10.0 : 13.0
    }
    
}
