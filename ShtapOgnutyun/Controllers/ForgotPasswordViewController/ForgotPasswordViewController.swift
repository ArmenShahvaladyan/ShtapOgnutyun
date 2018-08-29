//
//  ForgotPasswordViewController.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 6/19/18.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController ,UITextFieldDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    @IBOutlet weak var codeTextField: UITextField?
    @IBOutlet weak var passwordTextField: UITextField?
    @IBOutlet weak var confirmPasswordTextField: UITextField?
    @IBOutlet weak var resendButton: UIButton?
    @IBOutlet weak var shadowView: ShadowView?
    
    // MARK: Variables
    var phoneNumber:String?
    var forgotPasswordData = [String:Any]()
    var activeTF:UITextField?
    var initialFrame: CGRect?
    
    //MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        codeTextField?.delegate = self
        passwordTextField?.delegate = self
        confirmPasswordTextField?.delegate = self
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(closeOpen))
        self.view.addGestureRecognizer(tapGesture)
        initialFrame = self.shadowView?.frame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "forgot_password".localized()
        addKeyboardNotification()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        removeKeyboardNotification()

    }

    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTF = textField
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
            openKeyBoard(frame.cgRectValue, (activeTF?.frame)!)
        }
    }
    
    @objc func keyboardWillHidden(notification: NSNotification) {
        if let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
            closeKeyBoard(frame.cgRectValue, (activeTF?.frame)!)
        }
    }
    
    func openKeyBoard(_ keyboardFrame: CGRect, _ tfFrame: CGRect) {
        var rect = self.shadowView?.convert(tfFrame, to: self.view)
        rect?.origin.y += tfFrame.size.height
        var aRect = self.view.frame
        aRect.size.height -= keyboardFrame.size.height;
        aRect.origin.y = 0
        if rect != CGRect.zero {
            if !((aRect.contains((rect?.origin)!))) {
                let y: CGFloat = (rect?.origin.y)! - aRect.height
                let multiplier: CGFloat = 1 - 2.0 / (y - 10)
                self.centerConstraint = self.centerConstraint.changeMultiplier(multiplier: multiplier)

                UIView.animate(withDuration: 0.5, animations: {
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func closeKeyBoard(_ keyboardFrame: CGRect, _ tfFrame: CGRect) {
        self.centerConstraint = self.centerConstraint.changeMultiplier(multiplier: 1)

        UIView.animate(withDuration: 0.5, animations: {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        })
    }
    
    //MARK: Fields validations
    private func validateFields() -> Bool {
        let code = codeTextField?.text
        let password = passwordTextField?.text
        let confirmPassword = confirmPasswordTextField?.text
        if code == "" {
            self.showToastRequiredCode()
        } else if Validator().isValidCode(code: code) {
            forgotPasswordData["code"] = code?.replacingOccurrences(of: " ", with: "")
        } else {
            self.showToastWrongCodeFormat()
        }
        
        if password != "" && Validator().isValidPassword(passwordString: password) {
            forgotPasswordData["password"] = password?.replacingOccurrences(of: " ", with: "")
        } else {
            self.showToastForFillPasswordField()
            return false
        }
        
        if confirmPassword != "" && Validator().isValidConfirmPassword(passwordString: password!, confirmPasswordString: confirmPassword!) {
            forgotPasswordData["confirmPassword"] = confirmPassword?.replacingOccurrences(of: " ", with: "")
        } else {
            self.showToastForFillConfirmPasswordField()
            return false
        }
        
        if phoneNumber != "" {
            forgotPasswordData["phone"] = phoneNumber
        }
        
        return true
    }
    
    //MARK: Button clicks
    @IBAction func resendButtonClick(_ sender: UIButton) {
        sendButtonClick()
    }
    
    @objc func showAlertForSuccsesfulyPasswordChange() {
        if let _ = self.navigationController?.viewControllers.first as? HomeViewController {
            if let loginVC = self.navigationController?.viewControllers[3] as? ContentViewController {
                self.navigationController?.popToViewController(loginVC, animated: true)
            }
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func sendButtonClick() {
        self.view.endEditing(true)
        self.cancelAllToast()
        if validateFields(){
            SOIndicator.showInView(self.view)
            UserRequestSevice.sharedInstance.forgotPassword(userParams: forgotPasswordData, succsesBlock: {
                SOIndicator.hide()
                self.showAlertForSuccsesfulyPasswordChange()
                self.perform(#selector(self.showAlertForSuccsesfulyPasswordChange), with: self, afterDelay: 2.0)
                
            }) { (error) in
                SOIndicator.hide()
                if let errorData = error as? [String: Any] {
                    SIErrorHelper().checkErrorForgotPasswordWith(data: errorData, viewController: self)
                }
            }
        }
    }
    
}

