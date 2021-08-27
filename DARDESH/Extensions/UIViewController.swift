//
//  UIView.swift
//  DARDESH
//
//  Created by Mohamed Ali on 29/06/2021.
//

import UIKit
import RappleProgressHUD
import Gallery

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
    }
    
    func stopAnimating() {
        RappleActivityIndicatorView.stopAnimation()
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
    
    
    func OpenGalleyWithConfig (VC: GalleryControllerDelegate, initTap: Config.GalleryTab , numberOfImages: Int , tapsType: [Config.GalleryTab]) {
        
        let gallery = GalleryController()
        Config.tabsToShow = tapsType
        Config.initialTab = initTap
        Config.Camera.imageLimit = numberOfImages
        Config.VideoEditor.maximumDuration = 30
        gallery.delegate = VC
        gallery.modalPresentationStyle = .fullScreen
        self.present(gallery, animated: true)
        
    }
    
}
