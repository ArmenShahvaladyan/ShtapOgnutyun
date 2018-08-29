//
//  LoginViewController.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 5/2/18.
//  Copyright © 2018 My Mac. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, UITextFieldDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var phoneTextField: UITextField? {
        didSet {
            phoneTextField?.text = "+374"
            
        }
    }
    @IBOutlet weak var passwordTextField: UITextField?
    @IBOutlet weak var createAccountButton: SOLocalizedButton?
    @IBOutlet weak var loginButton: BorderedButton?
    @IBOutlet weak var forgotPassword: UIButton?
    
    // MARK: Variables
    var activeTF:UITextField?
    var loginData = [String: Any]()
    var logButtonClick: ((_ isUserActivate: Bool)->())?
    var openRegistreVC: (()->())?
    var openKeyboard: ((_ keyboardFrame: CGRect, _ tfFrame: CGRect)->())?
    var closeKeyboard: ((_ keyboardFrame: CGRect, _ tfFrame: CGRect)->())?
    
    //MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTextField?.delegate = self
        passwordTextField?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpLoaclization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.endEditing(true)
    }
    
    func setUpLoaclization() {
        phoneTextField?.placeholder = "phone".localized()
        passwordTextField?.placeholder = "password".localized()
        createAccountButton?.setTitle("create_new_account".localized(), for: .normal)
        loginButton?.setTitle("login".localized(), for: .normal)
        let myNormalAttributedTitle = NSAttributedString.init(string: "forgot_password".localized(), attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray, NSAttributedStringKey.underlineStyle:1])
        forgotPassword?.setAttributedTitle(myNormalAttributedTitle, for: .normal)
    }
    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTF = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if activeTF == phoneTextField {
            if range.length == 1 {
                if range.location == 0 || range.location == 1 || range.location == 2 || range.location == 3 || (phoneTextField?.text?.count)! < 5 {
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
    
    //MARK: Fields validations
    private func validateFields() -> Bool {
        var phoneText = phoneTextField?.text
        let passwordText = passwordTextField?.text
        
        
        if phoneText != "" && (phoneText?.count)! > 4  {
            let zeroIndx =  phoneText?.index(of: "0")
            if zeroIndx?.encodedOffset == 4 {
                let range = Range.init(NSRange.init(location: 4, length: 1), in: phoneText!)
                phoneText = phoneText?.replacingOccurrences(of: "0", with: "", options: .literal, range: range)
            }
            loginData["phone"] = phoneText?.replacingOccurrences(of: " ", with: "")
        } else {
            self.showToastForFillPhoneField()
            return false
        }
        
        if passwordText != "" && Validator().isValidPassword(passwordString: passwordText) {
            loginData["password"] = passwordText
        } else {
            self.showToastForPasswordFormat()
            return false
        }
        
        return true
    }
    
    //MARK: Button Clicks
    
    @IBAction func loginButtonClick(_ sender: UIButton) {
        self.view.endEditing(true)
        self.cancelAllToast()
        if validateFields() {
            SOIndicator.showInView((self.parent?.view)!)
            UserRequestSevice.sharedInstance.loginProfile(loginData: loginData, succsesBlock: { (user) in
                SOIndicator.hide()
                if self.logButtonClick != nil {
                    self.logButtonClick!(true)
                }
            }) { (error) in
                SOIndicator.hide()
                if error as? String == Constant.kSINotInternetConectionError {
                    self.showToastForNotInternetConnection()
                }
                if let errorData = error as? [String: Any] {
                    SIErrorHelper().checkLoginErrorBy(data: errorData, viewController: self, forbidden: {
                        if self.logButtonClick != nil {
                            self.logButtonClick!(false)
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func forgotPasswordButtonClick(_ sender: UIButton) {
        let resendPasswordVC = ResendPasswordCodeViewController.init(nibName: "ResendPasswordCodeViewController", bundle: nil)
        self.removeKeyboardNotification()
        self.navigationController?.pushViewController(resendPasswordVC, animated: true)
    }
    
    @IBAction func registreButtonClick(_ sender: UIButton) {
        removeKeyboardNotification()
        if openRegistreVC != nil {
            openRegistreVC!()
        }
    }
    
}
