//
//  UIView.swift
//  DARDESH
//
//  Created by Mohamed Ali on 29/06/2021.
//

import UIKit
import ProgressHUD

extension UIViewController {
    
    func ShowLabelWithAnimation (LabelName: UILabel) {
        UIView.animate(withDuration: 0.6) {
            LabelName.isHidden = false
            self.view.layoutIfNeeded()
        }
    }
    
    func HideLabelWithAnimation (LabelName: UILabel) {
        UIView.animate(withDuration: 0.5) {
            LabelName.isHidden = true
            self.view.layoutIfNeeded()
        }
    }
    
    func showAnimation() {
        ProgressHUD.show("Please Wait")
    }
    
    func stopAnimating() {
        ProgressHUD.dismiss()
    }
    
}
