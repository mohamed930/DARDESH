//
//  UIView.swift
//  DARDESH
//
//  Created by Mohamed Ali on 29/06/2021.
//

import UIKit
import RappleProgressHUD

let transictionTime = 0.3

extension UIViewController {
    
    func ShowLabelWithAnimation (LabelName: UILabel) {
        UIView.animate(withDuration: 0.6) {
            LabelName.isHidden = false
            self.view.layoutIfNeeded()
        }
    }
    
    func HideLabelWithAnimation (LabelName: UILabel) {
        UIView.animate(withDuration: 0.6) {
            LabelName.isHidden = true
            self.view.layoutIfNeeded()
        }
    }
    
    func showAnimation() {
        RappleActivityIndicatorView.startAnimatingWithLabel("WaitMess".localized, attributes: RappleAppleAttributes)
//        ProgressHUD.show("WaitMess".localized)
    }
    
    func stopAnimating() {
        RappleActivityIndicatorView.stopAnimation()
//        ProgressHUD.dismiss()
    }
    
    func presentDetailEn(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = transictionTime
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)

        viewControllerToPresent.modalPresentationStyle = .fullScreen
        
        present(viewControllerToPresent, animated: false)
    }

    func dismissDetailEn() {
        let transition = CATransition()
        transition.duration = transictionTime
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)

        dismiss(animated: false)
    }
    
    func presentDetailAr(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = transictionTime
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)

        viewControllerToPresent.modalPresentationStyle = .fullScreen
        
        present(viewControllerToPresent, animated: false)
    }

    func dismissDetailAr() {
        let transition = CATransition()
        transition.duration = transictionTime
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)

        dismiss(animated: false)
    }
    
}
