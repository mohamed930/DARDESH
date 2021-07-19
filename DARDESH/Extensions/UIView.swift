//
//  UIView.swift
//  DARDESH
//
//  Created by Mohamed Ali on 19/07/2021.
//

import UIKit

extension UIView {
    
    func MakeViewCircle() {
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true

        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2.5
    }
    
}

