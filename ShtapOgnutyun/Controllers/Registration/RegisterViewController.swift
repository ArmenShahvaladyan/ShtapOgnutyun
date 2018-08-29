    //
//  RegisterViewController.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 5/2/18.
//  Copyright © 2018 My Mac. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController , UITextFieldDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var fullNameTF: UITextField?
    @IBOutlet weak var emailTF: UITextField?
    @IBOutlet weak var phoneNumnbrTF: UITextField? {
        didSet {
            phoneNumnbrTF?.text = "+374"
        }
    }
    @IBOutlet weak var passwordTF: UITextField?
    @IBOutlet weak var confirmPasswordTF: UITextField?
    @IBOutlet weak var regButton: UIButton?
    @IBOutlet weak var haveAccountButton: SOLocalizedButton?
    
    // MARK: Variables
    var registreData = [String: Any]()
    var openLoginVC: (()->())?
    var regButtonClick: (()->())?
    var openKeyboard: ((_ keyboardFrame: CGRect, _ tfFrame: CGRect)->())?
    var closeKeyboard: ((_ keyboardFrame: CGRect, _ tfFrame: CGRect)->())?
    var activeTF:UITextField?

    
    //MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        fullNameTF?.delegate = self
        emailTF?.delegate = self
        phoneNumnbrTF?.delegate = self
        passwordTF?.delegate = self
        confirmPasswordTF?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target:nil, action: nil)
        setLocalizations()
    }
    
    func setLocalizations() {
        fullNameTF?.placeholder = "full_name".localized()
        emailTF?.placeholder = "email_address".localized()
        phoneNumnbrTF?.placeholder = "phone_number".localized()
        passwordTF?.placeholder = "password".localized()
        confirmPasswordTF?.placeholder = "confirm_password".localized()
        regButton?.setTitle("register".localized(), for: .normal)
        haveAccountButton?.setTitle("have_an_account".localized(), for: .normal)
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTF = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if activeTF == phoneNumnbrTF {
            if range.length == 1 {
                if range.location == 0 || range.location == 1 || range.location == 2 || range.location == 3 || (phoneNumnbrTF?.text?.count)! < 5 {
                    return false
                }
            } else {
                if range.location == 0 || range.location == 1 || range.location == 2 || range.location == 3 {
                    return false
                }
            }
        }
        return true
    }
    
    //MARK: Fields validations
    private func validateFields() -> Bool {
        
        let fullName = fullNameTF?.text
        let email = emailTF?.text
        let phoneNumber = phoneNumnbrTF?.text
        let password = passwordTF?.text
        let confirmPassword = confirmPasswordTF?.text
        
        if fullName != "" && Validator().isValidName(name: fullName) {
            registreData["User[fName]"] = fullName
        } else {
            self.showToastForFirstnameFormat()
            return false
        }
        
        registreData["User[email]"] = email
        
        if phoneNumber != "" && (phoneNumber?.count)! > 4 {
            registreData["User[phone]"] = phoneNumber
        } else {
            self.self.showToastForFillPhoneField()
            return false
        }
        
        if password != "" && Validator().isValidPassword(passwordString: password) {
            registreData["User[password]"] = password
        } else {
            self.showToastForFillPasswordField()
            return false
        }
        
        if confirmPassword != "" && password == confirmPassword {
            
        } else {
            self.showToastForFillConfirmPasswordField()
            return false
        }
        
        return true
    }
    
    //MARK: Button Clicks
    @IBAction func regButtonClick(_ sender: UIButton) {
        self.cancelAllToast()
        self.view.endEditing(true)
        if validateFields() {
            registreUser(userParams: registreData)
        }
    }
    
    @IBAction func openLoginVC(_ sender: UIButton) {
        if openLoginVC != nil {
            openLoginVC!()
        }
    }
    
    //MARK: Registration request
    
    func registreUser(userParams:[String:Any]) {
        SOIndicator.showInView((self.parent?.view)!)
        UserRequestSevice.sharedInstance.createUser(userParams: userParams, succsesBlock: { (succsesData) in
            SOIndicator.hide()
            if let data = succsesData["data"] as? [String: Any] {
                let token = data["token"] as? String
                UserDefaults.standard.set(token, forKey: Constant.kToken)
                UserDefaults.standard.synchronize()
                self.showActivateAlertWith(phoneNumber: (self.phoneNumnbrTF?.text)!, sendAction: { code in
                    self.activateProfile(code: code, succses: {
                        SOIndicator.hide()
                        if self.regButtonClick != nil {
                            self.regButtonClick!()
                        }
                    }, failure: { error in
                        SOIndicator.hide()
                        if error as? String == Constant.kSINotInternetConectionError {
                            self.showToastForNotInternetConnection()
                        }
                        if let errorData = error as? [String: Any] {
                            SIErrorHelper().checkActivateUserProfile(data: errorData, viewController: self)
                        }
                    })
                })
            }
        }) { (error) in
            SOIndicator.hide()
            if error as? String == Constant.kSINotInternetConectionError {
                self.showToastForNotInternetConnection()
            }
            if let errorData = error as? [String: Any] {
                SIErrorHelper().checkCreateUserErrorBy(data: errorData, viewController: self)
            }
        }
    }
    
    //MARK: Keyboard Notifications
    
    func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden), name: .UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func closeOpen() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
            if openKeyboard != nil {
                openKeyboard!(frame.cgRectValue, (activeTF?.frame)!)
            }
        }
    }
    
    @objc func keyboardWillHidden(notification: NSNotification) {
                if let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
                    if closeKeyboard != nil {
                        closeKeyboard!(frame.cgRectValue, (activeTF?.frame)!)
                }
        }
    }
}
