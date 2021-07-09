//
//  ExtensionEditProfileViewController.swift
//  DARDESH
//
//  Created by Mohamed Ali on 04/07/2021.
//

import UIKit
import Gallery
import ProgressHUD

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

extension EditProfileViewController: GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 1 {
            let mess = "ChooceImageActionFalse".localized
            ProgressHUD.showError(mess , interaction: true)
        }
        else {
            images[0].resolve(completion: { [weak self] img in
                
                guard let self = self else { return }
                
                self.ProfileImageView.image = img
                
                controller.dismiss(animated: true, completion: nil)
                
                self.editviewmodel.PickedImageBehaviour.accept(img!)
                self.editviewmodel.UpdateProfileImageOperation()
            })
        }

    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        print("requestLightbox Selected")
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        print("Video Selected")
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        print("Canceled Selected")

        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
}
