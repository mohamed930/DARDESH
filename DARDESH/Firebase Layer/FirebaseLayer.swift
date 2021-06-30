//
//  FirebaseLayer.swift
//  DARDESH
//
//  Created by Mohamed Ali on 29/06/2021.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class FirebaseLayer {
    
    // MARK:- TODO:- This Method for Write data to dicrect child
    // ---------------------------------------------------------
    public static func write(childName:String,childID:String,value:[String:Any]) {
        
        Database.database().reference()
            .child(childName).child(childID)
        .setValue(value){
            (error:Error?, ref:DatabaseReference) in
            if error != nil {
                print("Error")
            }
            else {
                print("Sent success")
            }
        }
    }
    // ---------------------------------------------------------
    
    
    // MARK:- TODO:- This Method for Read data to direct child
    // ---------------------------------------------------------
    public static func readwithoutcondtion(childName:String, complention: @escaping (DataSnapshot) -> ()) {
        
        Database.database().reference().child(childName).observe(.childAdded, with: { (snap) in
            complention(snap)
        }) { (error) in
            print("Error")
        }
    }
    // ---------------------------------------------------------
    
    
    // MARK:- TODO:- This Method for Read data to direct child with condtion
    // ---------------------------------------------------------------------
    public static func readwithcondtion(childName:String,k:String,v:String, complention: @escaping (DataSnapshot) -> ()) {
        
        Database.database().reference().child(childName).queryOrdered(byChild: k).queryEqual(toValue: v).observe(.childAdded) { (snap) in
            complention(snap)
        }
    }
    // ---------------------------------------------------------------------
    
    
    // MARK:- TODO:- This Method for Upload Image.
    // --------------------------------------------
    public static func uploadMedia(ImageName:String,PickedImage:UIImage,completion: @escaping (_ url: String?) -> Void) {
        
       let StorageRef = Storage.storage().reference(forURL: imageFolder)
       let starsRef = StorageRef.child(ImageName)
        if let uploadData = PickedImage.pngData() {
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            starsRef.putData(uploadData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("error")
                    completion(nil)
                } else {
                    starsRef.downloadURL { (url, error) in
                        if error != nil {
                            print("error")
                        }
                        else {
                            completion(url?.absoluteString)
                        }
                    }
                }
            }
        }
        
    }
    // --------------------------------------------
    
}
