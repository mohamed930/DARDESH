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
    }
    
    func TextFieldToViewModel() {
        EmailTextField.rx.text.orEmpty.bind(to: loginviewmodel.EmailBehaviour).disposed(by: disposebag)
        PasswordTextField.rx.text.orEmpty.bind(to: loginviewmodel.PasswordBehaviour).disposed(by: disposebag)
    }
    
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
    
    func subscribeToresponse() {
        loginviewmodel.loginsModelSubjectObserval.subscribe(onNext: { [weak self] result in
            
            guard let self = self else { return }
            
            if result == "Success" {
                print("Login is Successfully")
            }
            else {
                print("Login is Failed")
                ProgressHUD.showError("email or password isn't correct")
                self.PasswordTextField.text = ""
//                self.PasswordTextField.becomeFirstResponder()
            }
        }).disposed(by: disposebag)
    }
    
    func subscribeisLoginEnabeld() {
        loginviewmodel.isLoginButtonEnabled
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposebag)
    }
    
    func loginsubscribeTap() {
        loginButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] (_) in
            
            guard let self = self else { return }
            
            self.view.endEditing(true)
            
            self.loginviewmodel.LoginOperation()
            
        }).disposed(by: disposebag)
    }
    
    
    @IBAction func SignUpAction(_ sender: Any) {
        
        let story = UIStoryboard(name: "LoginMain", bundle: nil)
        let next  = story.instantiateViewController(withIdentifier: "RegsterViewController") as! RegsterViewController
        
        next.modalPresentationStyle = .fullScreen
        
        self.present(next, animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.tag == 1 {
            if EmailTextField.hasText {
                self.ShowLabelWithAnimation(LabelName: EmailLabel)
            }
            else {
                self.HideLabelWithAnimation(LabelName: EmailLabel)
            }
            
        }
        else {
            if PasswordTextField.hasText {
                self.ShowLabelWithAnimation(LabelName: PasswordLabel)
            }
            else {
                self.HideLabelWithAnimation(LabelName: PasswordLabel)
            }
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            self.PasswordTextField.becomeFirstResponder()
        }
        else {
            self.view.endEditing(true)
            self.loginviewmodel.LoginOperation()
        }
        
        return true
    }
    
}
