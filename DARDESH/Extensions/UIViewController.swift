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
    
    func showAnimation() {
        ProgressHUD.show()
    }
    
    func stopAnimating() {
        ProgressHUD.dismiss()
    }
    
}
