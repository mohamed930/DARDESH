//
//  GalleryExtension.swift
//  DARDESH
//
//  Created by Mohamed Ali on 26/08/2021.
//

import Foundation
import Gallery

extension MessageViewController:  GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 1 {
            
            Image.resolve(images: images) { [weak self] Imgarray in
                
                guard let self = self else { return }
                
                for i in Imgarray {
                    self.messageviewmodel.sendMessageImageOperation(PickedImage: i!)
                }
                
                // After Picking Image Dismiss Gallery
                controller.dismiss(animated: true)
            }
            
        }
        else if images.count == 1 {
            
            images[0].resolve(completion: { [weak self] img in
                
                guard let self = self else { return }
                
                self.messageviewmodel.responseReadedBehaviour.accept(false)
                self.messageviewmodel.sendMessageImageOperation(PickedImage: img!)
                
                // After Picking Image Dismiss Gallery
                controller.dismiss(animated: true)
                
            })
            
        }
        
        
        
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        print("Video Selected")
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        print("request Licght Box Selected")
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        print("Canceled Selected")

        controller.dismiss(animated: true)
    }
    
    
}
