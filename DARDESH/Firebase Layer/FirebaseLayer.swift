//
//  FirebaseLayer.swift
//  DARDESH
//
//  Created by Mohamed Ali on 29/06/2021.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore
import FirebaseAuth

class FirebaseLayer {
    
   // MARK:- TODO:- This Method For Adding Data to Firebase.
   public static func addData (collectionName:String,data:[String:Any]) {
       
       Firestore.firestore().collection(collectionName).document().setData(data){
           error in
           if error != nil {
               print("Error")
           }
           else {
               print("Success")
           }
       }
   }
    
    
    // MARK:- TODO:- This Method For Signup completly to Firebase.
    // collectionName:String,data:[String:String]
    public static func createAccount(Email:String,Password:String,completion: @escaping (String) -> ()) {
        
        Auth.auth().createUser(withEmail: Email, password: Password) { (auth, error) in
            if error != nil {
                print("Error")
                completion("Failed")
            }
            else {
               // self.addData(collectionName: collectionName, data: data)
                completion("Success")
            }
        }
    }
    
    
    // MARK:- TODO:- This Method For Make a login opertation.
    public static func MakeLogin (Email:String,Password:String,completion: @escaping (String) -> ())  {
           
           Auth.auth().signIn(withEmail: Email, password: Password) { (auth, error) in
               if error != nil {
                   completion("Failed")
               }
               else {
                   completion("Success")
               }
           }
           
    }
    
    // MARK:- TODO:- This Method for Read Data from Firebase with condtion in public.
    public static func publicreadWithWhereCondtion (collectionName:String , key:String , value:String , complention: @escaping (QuerySnapshot) -> ()) {
            
          //  RappleActivityIndicatorView.startAnimatingWithLabel("loading", attributes: RappleModernAttributes)
            Firestore.firestore().collection(collectionName).whereField(key, isEqualTo: value).getDocuments { (quary, error) in
                if error != nil {
                    print("Error")
                }
                else {
                    complention(quary!)
                }
            }
    }
        
    
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
