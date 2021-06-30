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
    
    func TextFieldToViewModel() {
        EmailTextField.rx.text.orEmpty.bind(to: regesterviewmodel.emailBehaviour).disposed(by: disposebag)
        PasswordTextField.rx.text.orEmpty.bind(to: regesterviewmodel.passwordBehaviour).disposed(by: disposebag)
        ConfirmPasswordTextField.rx.text.orEmpty.bind(to: regesterviewmodel.confirmPasswordBehaviour).disposed(by: disposebag)
    }
    
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
    
    func subscribeToresponse() {
        regesterviewmodel.CreatedModelSubjectObserval.subscribe(onNext: { [weak self] result in
            
            guard let self = self else { return }
            
            if result == "Success" {
                print("Regester is Successfully")
                ProgressHUD.showSuccess("Regester is Successfully")
            }
            else {
                print("Regester is Failed")
                self.PasswordTextField.text = ""
                self.ConfirmPasswordTextField.text = ""
                ProgressHUD.showError("email is used before try to change it")
            }
        }).disposed(by: disposebag)
    }
    
    func subscribeisLoginEnabeld() {
        regesterviewmodel.isRegesterButtonEnabled
            .bind(to: RegesterButton.rx.isEnabled)
            .disposed(by: disposebag)
    }
    
    func RegestersubscribeTap() {
        RegesterButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] (_) in
            
            guard let self = self else { return }
            
            self.view.endEditing(true)
            
            self.regesterviewmodel.RegesterOperation()
            
        }).disposed(by: disposebag)
    }
    
    @IBAction func LoginAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}


extension RegsterViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField.tag {
        case 1:
             EmailTextField.hasText ? self.ShowLabelWithAnimation(LabelName: EmailLabel) : self.HideLabelWithAnimation(LabelName: EmailLabel)
        case 2:
            PasswordTextField.hasText ? self.ShowLabelWithAnimation(LabelName: PasswordLabel) : self.HideLabelWithAnimation(LabelName: PasswordLabel)
        default:
            ConfirmPasswordTextField.hasText ? self.ShowLabelWithAnimation(LabelName:  ConfirmLabel) : self.HideLabelWithAnimation(LabelName: ConfirmLabel)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1:
            PasswordTextField.becomeFirstResponder()
        case 2:
            ConfirmPasswordTextField.becomeFirstResponder()
        default:
            self.view.endEditing(true)
        }
        return true
    }
}
