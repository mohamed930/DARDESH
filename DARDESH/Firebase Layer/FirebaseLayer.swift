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
import ProgressHUD

class FirebaseLayer {
    
    public static func refernceCollection (_ collectionName:String) -> CollectionReference {
        return Firestore.firestore().collection(collectionName)
    }
    
    
    // MARK:- TODO:- This Method For Signup completly to Firebase.
    public static func createAccount(Email:String,Password:String,completion: @escaping (String,AuthDataResult?) -> ()) {
        
        Auth.auth().createUser(withEmail: Email, password: Password) { (auth, error) in
            if error != nil {
                completion(error!.localizedDescription,auth)
            }
            else {
                completion("Success",auth)
            }
        }
    }
    
    
    // MARK:- TODO:- This Method for Read Data from Firebase with condtion in public.
    public static func publicreadWithWhereCondtion (collectionName:String , key:String , value:String , complention: @escaping (QuerySnapshot) -> ()) {
        
        Firestore.firestore().collection(collectionName).whereField(key, isEqualTo: value).getDocuments { (quary, error) in
            if error != nil {
                ProgressHUD.showError("We Can't Find Your Data!")
            }
            else {
                complention(quary!)
            }
        }
    }
    
    
    // MARK:- TODO:- This Method For Make a login opertation.
    public static func MakeLogin (Email:String,Password:String,completion: @escaping (AuthDataResult?,Error?) -> ())  {
           
           Auth.auth().signIn(withEmail: Email, password: Password) { (auth, error) in
               completion(auth,error)
           }
           
    }
    
    // MARK:- TODO:- This Method For Send Password resete operation.
    public static func resetPassword (Email: String, completion: @escaping (String) -> ()) {
        
        Auth.auth().sendPasswordReset(withEmail: Email) { error in
            if error != nil {
                completion(error!.localizedDescription)
            }
            else {
                completion("Sent Successed")
            }
        }
        
    }
    
    // MARK:- TODO:- This Method for Send Email Verfication again to user.
    public static func SendEmailVerifcation (completion: @escaping (String) -> ()) {
        
        Auth.auth().currentUser?.reload(completion: { error in
            if error != nil {
                completion(error!.localizedDescription)
            }
            else {
                if (!Auth.auth().currentUser!.isEmailVerified) {
                    //resend verification email
                    completion("Email Sent successfully")
                } else {
                     //login
                    completion("you can go to login now")
                }
            }
        })
        
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
