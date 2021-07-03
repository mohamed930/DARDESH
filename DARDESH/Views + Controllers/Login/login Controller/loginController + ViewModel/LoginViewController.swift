//
//  LoginViewController.swift
//  DARDESH
//
//  Created by Mohamed Ali on 29/06/2021.
//

import UIKit
import RxCocoa
import RxSwift
import ProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var PasswordLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var ForgetPasswordButton: UIButton!
    
    let loginviewmodel = LoginViewModel()
    let disposebag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        TextFieldToViewModel()
        subscribeToLoading()
        subscribeToresponse()
        subscribeisLoginEnabeld()
        loginsubscribeTap()
        
        CheckResetePasswordEnabled()
        subscribeToresponseResete()
        ResetePasswordsubscribeTap()
    }
    
    // MARK:- TODO:- observe our textfield to viewmodel
    func TextFieldToViewModel() {
        EmailTextField.rx.text.orEmpty.bind(to: loginviewmodel.EmailBehaviour).disposed(by: disposebag)
        PasswordTextField.rx.text.orEmpty.bind(to: loginviewmodel.PasswordBehaviour).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- work with loading if value is true load or stop
    func subscribeToLoading() {
        loginviewmodel.loadingBehaviour.subscribe(onNext: { isloading in
            if isloading {
                self.showAnimation()
            }
            else {
                self.stopAnimating()
            }
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- get response from firebase if login is success or not.
    func subscribeToresponse() {
        loginviewmodel.loginsModelSubjectObserval.subscribe(onNext: { [weak self] result in
            
            guard let self = self else { return }
            
            if result == "Success" {
                print("Login is Successfully")
                
                // Go to ChatVC.
                let story = UIStoryboard(name: "HomeView", bundle: nil)
                let next  = story.instantiateViewController(withIdentifier: "ChatsViewControllers")
                next.modalPresentationStyle = .fullScreen
                self.present(next, animated: true, completion: nil)
            }
            else {
                print("Login is Failed \(result)")
                ProgressHUD.showError(result)
                self.PasswordTextField.text = ""
//                self.PasswordTextField.becomeFirstResponder()
            }
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- make validation if values is fill button work or not.
    func subscribeisLoginEnabeld() {
        loginviewmodel.isLoginButtonEnabled
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- make login action with rxswift
    func loginsubscribeTap() {
        loginButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] (_) in
            
            guard let self = self else { return }
            
            self.view.endEditing(true)
            
            // call login method from viewmodel
            self.loginviewmodel.LoginOperation()
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method is for validation before send resete email
    func CheckResetePasswordEnabled() {
        loginviewmodel.isPasswordResetrBehaviour
            .bind(to: ForgetPasswordButton.rx.isEnabled)
            .disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Action when email success or not.
    func subscribeToresponseResete() {
        
        loginviewmodel.resetePasssModelSubjectObserval.subscribe(onNext: { mess in
            
            if mess == "Email was sent please follow steps to resete password" {
                ProgressHUD.showSuccess("PasswordReseteMessage".localized)
            }
            else {
                ProgressHUD.showError(mess)
            }
            
        }).disposed(by: disposebag)
        
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Making Action for Reste Password.
    func ResetePasswordsubscribeTap () {
        
        ForgetPasswordButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] (_) in
            
            guard let self = self else { return }
            
            self.view.endEditing(true)
            
            // call login method from viewmodel
            self.loginviewmodel.ResetPasswordOperation()
            
        }).disposed(by: disposebag)
        
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- signup action button
    @IBAction func SignUpAction(_ sender: Any) {
        
        let story = UIStoryboard(name: "LoginMain", bundle: nil)
        let next  = story.instantiateViewController(withIdentifier: "RegsterViewController") as! RegsterViewController
        
        next.modalPresentationStyle = .fullScreen
        
        self.present(next, animated: true, completion: nil)
        
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- dismiss keypad if touch view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // ------------------------------------------------
}
