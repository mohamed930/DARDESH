//
//  AppDelegate.swift
//  DARDESH
//
//  Created by Mohamed Ali on 29/06/2021.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var firebaseListener: AuthStateDidChangeListenerHandle?
    let loginviewmodel = LoginViewModel()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        checkUserDefaults()
        return true
    }
    
    private func checkUserDefaults () {

        // let savedPerson = UserDefaults.standard.object(forKey: currentUser) as? Data
        // let decoder = JSONDecoder()
        // if let loadedPerson = try? decoder.decode(UserModel.self, from: savedPerson) {
        //      print("F: \(loadedPerson.UserName)")
        // }
        
        
        // First Check user in Firebase State && USERDefaults is exsist or not.
        firebaseListener = Auth.auth().addStateDidChangeListener({ [weak self] auth, user in
            
            guard let self = self else { return }
            
            Auth.auth().removeStateDidChangeListener(self.firebaseListener!)
            
            if user != nil && UserDefaults.standard.object(forKey: currentUser) as? Data != nil {
                
                DispatchQueue.main.async {
                    print("User exsist")
                    
                    // Send to chats we have login and we have to go chatsVC
                    self.loginviewmodel.DownloadData()
                    self.MakeViewControolerisInit(StroyName: "HomeView", Id: "ChatsViewControllers")
                }
                
            }
            else {
                print("user not found")
                
                // Sned to login failed and we have to go loginVC
                self.MakeViewControolerisInit(StroyName: "LoginMain", Id: "LoginViewController")
            }
        })

    }
    
    // MARK:- TODO:- This Method for Set root VC.
    private func MakeViewControolerisInit(StroyName: String ,Id: String) {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let storyboard = UIStoryboard(name: StroyName , bundle: nil)

        let initialViewController = storyboard.instantiateViewController(withIdentifier: Id)

        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()

    }
    // ------------------------------------------------

}
