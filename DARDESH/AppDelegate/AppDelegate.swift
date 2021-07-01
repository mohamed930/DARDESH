//
//  AppDelegate.swift
//  DARDESH
//
//  Created by Mohamed Ali on 29/06/2021.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

var LoginTag = false

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

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
        
        // First Check user in USERDefaults is exsist or not.
        if (UserDefaults.standard.object(forKey: currentUser) as? Data) != nil {
            print("User exsist")
            
            // Send to chats we have login and we have to go chatsVC
            LoginTag = true
            MakeViewControolerisInit(StroyName: "HomeView", Id: "ChatsViewControllers")
            
        }
        else {
            print("user not found")
            
            // Sned to login failed and we have to go loginVC
            LoginTag = false
            MakeViewControolerisInit(StroyName: "LoginMain", Id: "LoginViewController")
        }

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
