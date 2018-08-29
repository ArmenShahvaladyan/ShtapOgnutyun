//
//  ContentViewController.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 4/17/18.
//  Copyright © 2018 My Mac. All rights reserved.
//

import UIKit

enum ViewControllerPosition {
    case top
    case center
    case bottom
}

class ContentViewController: BaseViewController {
    
    // MARK: Variables
    
    var regVC:RegisterViewController?
    var logVC:LoginViewController?
    var onLoginFromHistory: (() -> ())?
    var onRegisterFromHistory: (() -> ())?

    private var isFirstLunchLogin: Bool = true
    private var visualEffectView: UIVisualEffectView!
    private var effect: UIVisualEffect!
    
    //MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(closeOpen))
        self.view.addGestureRecognizer(tapGesture)
        setup()
        addChildViewToParent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isFirstLunchLogin {
            self.title = "register".localized()
            changeRegistreViewPosition(animated: false)
        } else {
            logVC?.view.frame = loginFrame(position: .center)
            regVC?.view.isHidden = true
            self.regVC?.view.frame = registreFrame(position: .top)
            self.title = "login".localized()
            self.logVC?.addKeyboardNotification()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.logVC?.removeKeyboardNotification()
        self.regVC?.removeKeyboardNotification()
    }
    convenience init(login: Bool) {
        self.init()
        self.isFirstLunchLogin = login
    }
    
    deinit {

    }
    
    @objc func closeOpen() {
        self.view.endEditing(true)
    }
    
    //MARK: Private Api
    
    private func setup() {
        let bgImageView = UIImageView(frame: self.view.bounds)
        bgImageView.image = UIImage(named: "loginBackground")
        self.view.addSubview(bgImageView)
    }
    
    private func setupLogin() {
        guard logVC == nil else {
            return
        }
        
        let login: () -> () = {
            if self.onLoginFromHistory != nil {
                self.onLoginFromHistory!()
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        logVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
        logVC?.logButtonClick = { [weak self] isActiveUser in
            if isActiveUser {
                login()
            } else {
                self?.showAlertForActivateProfileWith(phoneNumber: (self?.logVC?.phoneTextField?.text)!, completion: {
                    login()
                }, failure: { error in
                    if let errorData = error as? [String: Any] {
                        SIErrorHelper().checkActivateUserProfile(data: errorData, viewController: self!)
                    }
                })
            }
        }
        
        logVC?.openRegistreVC = { [weak self] in
            self?.changeRegistreViewPosition(animated: true)
        }
        
        logVC?.openKeyboard = { [weak self] frame, tfFrame in
            
            var rect  = self?.view.convert(tfFrame, from: self?.logVC?.view)
            rect?.origin.y += tfFrame.size.height
            var aRect = self?.view.frame
            aRect?.size.height -= frame.size.height;
            
            if rect != CGRect.zero {
                if !(aRect?.contains((rect?.origin)!))! {
                    UIView.animate(withDuration: 1, animations: {
                        self?.logVC?.view.frame.origin = CGPoint.init(x:  (self?.logVC?.view.frame.origin.x)!, y: tfFrame.origin.y -  frame.height)
                    })
                }
            }
        }
        
        logVC?.closeKeyboard = { [weak self] frame , tfFrame in
            UIView.animate(withDuration: 1, animations: {
                self?.logVC?.view.frame.origin = (self?.loginFrame(position: .center).origin)!
            })
        }
        
        self.addChildViewController(childVC: logVC!, toView: self.view, childFrame: loginFrame(position: .center))
    }
    
    private func setupRegister() {
        guard regVC == nil else {
            return
        }
        regVC = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
        regVC?.regButtonClick = { [weak self] in
            if self?.onRegisterFromHistory != nil {
                self?.onRegisterFromHistory!()
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        regVC?.openLoginVC = { [weak self] in
            self?.changeLoginViewPosition()
        }
        
        regVC?.openKeyboard = { [weak self] frame, tfFrame in
            var rect  = self?.view.convert(tfFrame, from: self?.regVC?.view)
            rect?.origin.y += tfFrame.size.height
            var aRect = self?.view.frame
            aRect?.size.height -= frame.size.height;
            
            if rect != CGRect.zero {
                if !(aRect?.contains((rect?.origin)!))! {
                    UIView.animate(withDuration: 1, animations: {
                        self?.regVC?.view.frame.origin = CGPoint.init(x:  (self?.regVC?.view.frame.origin.x)!, y: tfFrame.origin.y -  frame.height)
                    })
                }
            }
        }
        
        regVC?.closeKeyboard = { [weak self] frame , tfFrame in
            UIView.animate(withDuration: 1, animations: {
                self?.regVC?.view.frame.origin = (self?.registreFrame(position: .center).origin)!
            })
        }
        
        self.addChildViewController(childVC: regVC!, toView: self.view, childFrame: registreFrame(position: .top))
    }
    
    private func addChildViewToParent() {
        setupLogin()
        setupRegister()
    }
    
    private func loginFrame(position: ViewControllerPosition) -> CGRect {
        let bounds = self.view.bounds
        var h: CGFloat = bounds.height
        if let navBarHeight = self.navigationController?.navigationBar.bounds.height {
            h -= navBarHeight
        }
        var rect = CGRect.zero
        rect.size.width = bounds.width - 40
        if UIDevice.isIPhoneX() {
            rect.size.height = h * 11 / 22
        } else {
            rect.size.height = h * 11 / 19
        }
        rect.origin.x = bounds.width / 2 - rect.width / 2
        if position == .top {
            rect.origin.y = -rect.height
        } else if position == .center {
            rect.origin.y = h / 2 - rect.height / 2
        } else {
            rect.origin.y = h
        }
        
        return rect
    }
    
    private func registreFrame(position: ViewControllerPosition) -> CGRect {
        let bounds = self.view.bounds
        var h: CGFloat = bounds.height
        if let navBarHeight = self.navigationController?.navigationBar.bounds.height {
            h -= navBarHeight
        }
    
        var rect = CGRect.zero
        rect.size.width = bounds.width - 40
        rect.size.height = h * 4 / 5
        rect.origin.x = bounds.width / 2 - rect.width / 2
        
        if position == .top {
            rect.origin.y = -rect.height
        } else if position == .center {
            rect.origin.y = h / 2 - rect.height / 2
        } else {
            rect.origin.y = h
        }
        
        return rect
    }
    
    private func changeLoginViewPosition() {
        self.title = "login".localized()
        UIView.animate(withDuration: 0.8, animations: {
            self.regVC?.view.frame = self.registreFrame(position: .bottom)
        }) { (complition) in
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveLinear, animations: {
                self.logVC?.view.frame = self.loginFrame(position: .center)
            }, completion: { (compplition) in
                self.logVC?.addKeyboardNotification()
                self.regVC?.view.frame = self.registreFrame(position: .top)
                self.regVC?.removeKeyboardNotification()
            })
        }
    }
    
    private func changeRegistreViewPosition(animated: Bool) {
        regVC?.view.isHidden = false
        self.title = "register".localized()
        if animated {
            UIView.animate(withDuration: 0.8, animations: {
                self.logVC?.view.frame = self.loginFrame(position: .bottom)
            }) { (complition) in
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveLinear, animations: {
                    self.regVC?.view.frame = self.registreFrame(position: .center)
                }, completion: { (compplition) in
                    self.regVC?.addKeyboardNotification()
                    self.logVC?.view.frame = self.loginFrame(position: .top)
                    self.logVC?.removeKeyboardNotification()
                })
            }
        } else {
            self.logVC?.view.frame = self.loginFrame(position: .bottom)
            self.regVC?.view.frame = self.registreFrame(position: .center)
            self.logVC?.view.frame = self.loginFrame(position: .top)
            self.regVC?.addKeyboardNotification()
            self.logVC?.removeKeyboardNotification()
        }
    }
}
