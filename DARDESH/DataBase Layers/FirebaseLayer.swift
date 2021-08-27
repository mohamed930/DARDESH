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
import RappleProgressHUD

class FirebaseLayer {
    
    static var newmessagesListner: ListenerRegistration!
    static var isTypingListner: ListenerRegistration!
    static var isReadedListner: ListenerRegistration!
    
    public static func refernceCollection (_ collectionName:String) -> CollectionReference {
        return Firestore.firestore().collection(collectionName)
    }
    
    // MARK:- TODO:- This Method For Write Message into Firebae
    public static func WriteMessageToFirebase (message: MessageModel, MemberId: String) {
        
        do {
            try FirebaseLayer.refernceCollection(messCollection).document(MemberId).collection(message.chatRoomId).document(message.id).setData(from: message) {
                error in
                
                if error != nil {
                    print("Error in writing")
                }
                
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    // ------------------------------------------------
    
    
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
    public static func publicreadWithWhereCondtion (collectionName:String , key:String , value:String , complention: @escaping (QuerySnapshot?) -> ()) {
        
        Firestore.firestore().collection(collectionName).whereField(key, isEqualTo: value).getDocuments { (quary, error) in
            if error != nil {
                ProgressHUD.showError("errorMess".localized)
            }
            else {
                complention(quary)
            }
        }
    }
    
    // MARK:- TODO:- This Method for Read Data from Firebase with condtion in public.
    public static func publicRealtimereadWithWhereCondtion (collectionName:String , key:String , value:String , complention: @escaping (QuerySnapshot?) -> ()) {
        
        Firestore.firestore().collection(collectionName).whereField(key, isEqualTo: value).addSnapshotListener { (quary, error) in
            if error != nil {
                ProgressHUD.showError("errorMess".localized)
            }
            else {
                complention(quary)
            }
        }
    }
    
    // MARK:- TODO:- This Method for Read Data from Firebase without condtion in public.
    public static func publicreadWithoutWhereCondtion (collectionName:String , complention: @escaping (QuerySnapshot? , Error?) -> ()) {
        
        Firestore.firestore().collection(collectionName).getDocuments { (quary, error) in
            if error != nil {
                complention(nil,error!)
            }
            else {
                complention(quary!,nil)
            }
        }
    }
    
    // MARK:- TODO:- This Method For Reading Old Messages From Firebase.
    public static func ReadOldMessages (collectionId: String, documntId: String, complention: @escaping (QuerySnapshot? , Error?) -> ()) {
        
        Firestore.firestore().collection(messCollection).document(documntId).collection(collectionId).getDocuments { Query, error in
            
            if error != nil {
                complention(nil,error!)
            }
            else {
                complention(Query,nil)
            }
        }
        
    }
    
    // MARK:- TODO:- This Method For Reading New Messages From Firebase.
    public static func RealtimeReadNewMessages (collectionId: String, documntId: String,LastMessageDate: Date, complention: @escaping (QuerySnapshot? , Error?) -> ()) {
        
        newmessagesListner = Firestore.firestore().collection(messCollection).document(documntId).collection(collectionId).whereField("date", isGreaterThan: LastMessageDate).addSnapshotListener({ Query, error in
            
            if error != nil {
                complention(nil,error!)
            }
            else {
                complention(Query,nil)
            }
            
        })
        
    }
    
    // MARK:- TODO:- This Method For Reading Status of Typing From Firebase.
    public static func RealtimeReadisTyping (ChatRoomId: String, complention: @escaping (DocumentSnapshot , Error?) -> ()) {
        
        isTypingListner = Firestore.firestore().collection(typingCollection).document(ChatRoomId).addSnapshotListener({ documntSnapShot, error in
            
            guard let snapshot = documntSnapShot else { return }
            
            if snapshot.exists {
                complention(snapshot,error)
            }
            else {
                
                Firestore.firestore().collection(typingCollection).document(ChatRoomId).setData([userID: false])
                
            }
            
        })
            
        
    }
    
    // MARK:- TODO:- This Method For Reading Message Status Listner From Firebase.
    public static func isReadedListner(documntId: String, collectionId: String,complention: @escaping (QuerySnapshot? , Error?) -> ()) {
        
        isReadedListner = Firestore.firestore().collection(messCollection).document(documntId).collection(collectionId).addSnapshotListener({ querysanpshot, error in
            
            if error != nil {
                complention(nil,error)
            }
            else {
                complention(querysanpshot,nil)
            }
            
        })
        
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
                    
                    // resend verification email
                    Auth.auth().currentUser?.sendEmailVerification(completion: { err in
                        if err != nil {
                            completion(err!.localizedDescription)
                        }
                        else {
                            completion("Email Sent successfully")
                        }
                    })
                    
                } else {
                     //login
                    completion("you can go to login now")
                }
            }
        })
        
    }
    
  
    // MARK:- TODO:- This Method For logout user from firebase.
    public static func LogoutUser (completion: @escaping (String) -> ()) {
        do {
            try Auth.auth().signOut()
            completion("Sign out Successfully")
            
        } catch {
            completion(error.localizedDescription)
        }
    }
    
    // MARK:- TODO:- This Method For Update Data from Firebase.
    public static func updateDocumnt (collectionName:String,documntId:String,data:[String:Any],completion: @escaping (Bool) -> ()) {
        
        Firestore.firestore().collection(collectionName).document(documntId).updateData(data){
            error in
            if error != nil {
                completion(false)
            }
            else {
                completion(true)
            }
        }
        
    }
    
    // MARK:- TODO:- This Method for Upload Image.
    // --------------------------------------------
    public static func uploadMedia(ImageFolder: String ,PickedImage:UIImage,completion: @escaping (_ url: String?) -> Void) {
        
       let StorageRef = Storage.storage().reference(forURL: imageFolder)
        let starsRef = StorageRef.child(ImageFolder)
       var task: StorageUploadTask!
        
        if let uploadData = PickedImage.jpegData(compressionQuality: 0.5) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            task = starsRef.putData(uploadData, metadata: metadata) { (metadata, error) in
                
                task.removeAllObservers()
                RappleActivityIndicatorView.stopAnimation()
                
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
            
            
            task.observe(.progress) { snapshot in
                let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount

                RappleActivityIndicatorView.setProgress(CGFloat(progress))
                
//                if CGFloat(progress) == 100 {
//                    RappleActivityIndicatorView.stopAnimation(completionIndicator: .success, completionLabel: "Completed.", completionTimeout: 1.0)
//                }
                

            }
            
        }
        
    }
    // --------------------------------------------
    
}
