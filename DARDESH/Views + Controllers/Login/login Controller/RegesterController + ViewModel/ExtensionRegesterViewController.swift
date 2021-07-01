//
//  ExtensionRegesterViewController.swift
//  DARDESH
//
//  Created by Mohamed Ali on 01/07/2021.
//

import UIKit

extension RegsterViewController: UITextFieldDelegate {
    
    // MARK:- TODO:- this method for show label and hide based on text.
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField.tag {
        case 1:
             EmailTextField.hasText ? self.ShowLabelWithAnimation(LabelName: EmailLabel) : self.HideLabelWithAnimation(LabelName: EmailLabel)
        case 2:
            PasswordTextField.hasText ? self.ShowLabelWithAnimation(LabelName: PasswordLabel) : self.HideLabelWithAnimation(LabelName: PasswordLabel)
        default:
            ConfirmPasswordTextField.hasText ? self.ShowLabelWithAnimation(LabelName:  ConfirmLabel) : self.HideLabelWithAnimation(LabelName: ConfirmLabel)
        }
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- this method for return button on keypad
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1:
            PasswordTextField.becomeFirstResponder()
        case 2:
            ConfirmPasswordTextField.becomeFirstResponder()
        default:
            self.view.endEditing(true)
            self.regesterviewmodel.RegesterOperation()
        }
        return true
    }
    // ------------------------------------------------
}
