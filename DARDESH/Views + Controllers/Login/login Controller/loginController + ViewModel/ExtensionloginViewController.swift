//
//  loginViewControllerExtension.swift
//  DARDESH
//
//  Created by Mohamed Ali on 01/07/2021.
//

import UIKit

extension LoginViewController: UITextFieldDelegate {
    
    // MARK:- TODO:- this method for show label and hide based on text.
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.tag == 1 {
            if EmailTextField.hasText {
                self.ShowLabelWithAnimation(LabelName: EmailLabel)
            }
            else {
                self.HideLabelWithAnimation(LabelName: EmailLabel)
            }
            
        }
        else {
            if PasswordTextField.hasText {
                self.ShowLabelWithAnimation(LabelName: PasswordLabel)
            }
            else {
                self.HideLabelWithAnimation(LabelName: PasswordLabel)
            }
            
        }
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- this method for return button on keypad
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            // for email go to password
            self.PasswordTextField.becomeFirstResponder()
        }
        else {
            // for password dismiss keypad and make login operation
            self.view.endEditing(true)
            self.loginviewmodel.LoginOperation()
        }
        
        return true
    }
}
