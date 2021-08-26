//
//  UIImageView.swift
//  DARDESH
//
//  Created by Mohamed Ali on 04/07/2021.
//

import UIKit

extension UIImageView {
    
    func MakeImageCircle() {
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true

        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2.5
    }
    
}


extension UIImage {
    
    func imageWithSize(scaledToSize newSize: CGSize) -> UIImage {
           UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
           self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
           let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
           UIGraphicsEndImageContext()
           return newImage
       }
    
}
