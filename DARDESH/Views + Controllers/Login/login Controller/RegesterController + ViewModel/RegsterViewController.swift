//
//  ViewController.swift
//  DARDESH
//
//  Created by Mohamed Ali on 29/06/2021.
//

import UIKit
import RxCocoa
import RxSwift
import ProgressHUD

class RegsterViewController: UIViewController {
    
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var PasswordLabel: UILabel!
    @IBOutlet weak var ConfirmLabel: UILabel!
    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var ConfirmPasswordTextField: UITextField!
    
    @IBOutlet weak var RegesterButton: UIButton!
    @IBOutlet weak var ResendEmailButton: UIButton!
    
    let regesterviewmodel = RegesterViewModel()
    let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TextFieldToViewModel()
        subscribeToLoading()
        subscribeToresponse()
        subscribeisLoginEnabeld()
        RegestersubscribeTap()
    }
    
    // MARK:- TODO:- observe our textfield to viewmodel
    func TextFieldToViewModel() {
        EmailTextField.rx.text.orEmpty.bind(to: regesterviewmodel.emailBehaviour).disposed(by: disposebag)
        PasswordTextField.rx.text.orEmpty.bind(to: regesterviewmodel.passwordBehaviour).disposed(by: disposebag)
        ConfirmPasswordTextField.rx.text.orEmpty.bind(to: regesterviewmodel.confirmPasswordBehaviour).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- work with loading if value is true load or stop
    func subscribeToLoading() {
        regesterviewmodel.loadingBehaviour.subscribe(onNext: { isloading in
            if isloading {
                self.showAnimation()
            }
            else {
                self.stopAnimating()
            }
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- get response from firebase if regester is success or not.
    func subscribeToresponse() {
        
        regesterviewmodel.CreatedModelSubjectObserval.subscribe(onNext: { [weak self] result in
            
            guard let self = self else { return }
            
            if result == "Success" {
                // success regester and go to Chats VC
                print("Regester is Successfully")
                ProgressHUD.showSuccess("Regester is Successfully")
                
                let story = UIStoryboard(name: "HomeView", bundle: nil)
                let next  = story.instantiateViewController(withIdentifier: "ChatsViewControllers")
                next.modalPresentationStyle = .fullScreen
                self.present(next, animated: true, completion: nil)
            }
            else {
                // failed clear password and confirm and sent message
                print("Regester is Failed")
                self.PasswordTextField.text = ""
                self.ConfirmPasswordTextField.text = ""
                ProgressHUD.showError(result)
            }
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- make validation if values is fill button work or not.
    func subscribeisLoginEnabeld() {
        regesterviewmodel.isRegesterButtonEnabled
            .bind(to: RegesterButton.rx.isEnabled)
            .disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- make regester action with rxswift
    func RegestersubscribeTap() {
        RegesterButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] (_) in
            
            guard let self = self else { return }
            
            self.view.endEditing(true)
            
            // make regester with viewmodel
            self.regesterviewmodel.RegesterOperation()
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- login action to dismiss this page to return login.
    @IBAction func LoginAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- dismiss keypad if touch view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // ------------------------------------------------
    
}
