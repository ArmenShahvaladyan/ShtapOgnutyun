//
//  ResendPasswordCodeViewController.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 6/19/18.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import UIKit

class ResendPasswordCodeViewController: BaseViewController , UITextFieldDelegate {
    
     // MARK: IBOutlets
    @IBOutlet weak var shadowView: ShadowView?
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneNumberTextField: UITextField?{
        didSet {
            phoneNumberTextField?.text = "+374"
        }
    }
    @IBOutlet weak var resendButton: BorderedButton?
    
    // MARK: Variables
    var phoneNumber:String?
    var activeTF:UITextField?
    var initialFrame: CGRect?
    
    //MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberTextField?.delegate = self
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(closeOpen))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "forgot_password".localized()
        self.resendButton?.setTitle("send".localized(), for: .normal)
        addKeyboardNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         initialFrame = self.shadowView?.frame
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        removeKeyboardNotification()
    }
    
    //MARK: Fields validations
    private func validateFields() -> Bool {
        let phoneText = phoneNumberTextField?.text
        if phoneText != "" && (phoneText?.count)! > 4 {
            phoneNumber = phoneText?.replacingOccurrences(of: " ", with: "")
        } else {
            self.self.showToastForFillPhoneField()
            return false
        }
        
        return true
    }
    
    @IBAction func resendButtonClick(_ sender: UIButton) {
        self.view.endEditing(true)
        self.cancelAllToast()
        if validateFields() {
            SOIndicator.showInView(self.view)
            UserRequestSevice.sharedInstance.resentSmsCode(phoneNumber: phoneNumber!, succsesBlock: { (responce) in
                SOIndicator.hide()
                let forgotPasswordVC = ForgotPasswordViewController.init(nibName: "ForgotPasswordViewController", bundle: nil)
                forgotPasswordVC.phoneNumber = self.phoneNumber
                self.navigationController?.pushViewController(forgotPasswordVC, animated: true)

            }, failerBlock: { (error) in
                SOIndicator.hide()
                if error as? String == Constant.kSINotInternetConectionError {
                    self.showToastForNotInternetConnection()
                }
                if let errorData = error as? [String :Any] {
                    SIErrorHelper().checkErrorResentSmsCodeWith(data: errorData, viewController: self)
                }
            })
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
                let multiplier: CGFloat = 1 - 2.0 / y
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
    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTF = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length == 1 {
            if range.location == 0 || range.location == 1 || range.location == 2 || range.location == 3 || (phoneNumberTextField?.text?.count)! < 5 {
                return false
            }
        } else {
            if range.location == 0 || range.location == 1 || range.location == 2 || range.location == 3 {
                return false
            }
        }
        return true
    }
    
}
