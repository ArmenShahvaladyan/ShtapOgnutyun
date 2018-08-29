//
//  ContactUsViewController.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 5/4/18.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import UIKit

class ContactUsViewController: BaseViewController {

    // MARK: IBOutlets
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var onlineOrderButton: UIButton!
    @IBOutlet weak var loginButton: BorderedButton!
    @IBOutlet weak var registerButton: BorderedButton!
    @IBOutlet weak var descriptionLabel: SOLocalizedLabel!
    @IBOutlet weak var callButtonTopConstraint: NSLayoutConstraint?
    @IBOutlet weak var callButtonWithConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: Variables
    private var isUserLogged:Bool {
        return UserRequestSevice.sharedInstance.currentUser?.isUserLogged ?? false
    }
    var workerId: Int?
    
    //MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
       // setConstraints()
    }
    
    func setConstraints() {
        callButton.translatesAutoresizingMaskIntoConstraints = false
        onlineOrderButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    //MARK: Public Api
    @IBAction func login() {
        let vc = ContentViewController.init(login: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func register() {
        let vc = ContentViewController.init(login: false)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func call() {
        let officePhoneNumber = UserDefaults.standard.value(forKey: "officePhoneNumber") as? String
        guard let numberUrl = URL(string: "tel://" + officePhoneNumber!) else { return }
        
        if UIApplication.shared.canOpenURL(numberUrl) {
            UIApplication.shared.open(numberUrl)
        } else {
            showAlertForCantOpenURL()
        }
    }
    
    @IBAction func onlineOrder() {
        self.cancelAllToast()
        UserRequestSevice.sharedInstance.createOrderWith(workerid: workerId!, succsesBlock: {
            self.showAlertView(nil, message: "your_order_is_confirmed".localized(), completion: { (action) in
                self.navigationController?.popToRootViewController(animated: true)
            })
        }) { error in
            if error as? String == Constant.kSINotInternetConectionError {
                self.showToastForNotInternetConnection()
            }
            if let errorData = error as? [String: Any] {
                SIErrorHelper().checkCreateOrderWith(data: errorData, viewController: self)
            }
        }
    }
    
    // MARK: Private Api
    
    private func setup() {
        self.title = "contact_us".localized()
        if isUserLogged {
            descriptionLabel.text = "contact_us_desc1".localized()
        } else {
            descriptionLabel.text = "contact_us_desc".localized()
        }
        onlineOrderButton.setTitle("online".localized(), for: .normal)
        loginButton.setTitle("login".localized(), for: .normal)
        registerButton.setTitle("register".localized(), for: .normal)
        if self.isUserLogged {
            loginButton.isHidden = true
            registerButton.isHidden = true
            onlineOrderButton.isHidden = false
            callButtonTopConstraint?.constant = 20
            callButtonWithConstraint = callButtonWithConstraint.changeMultiplier(multiplier: 0.49)
            contentViewHeightConstraint = contentViewHeightConstraint.changeMultiplier(multiplier: 0.36)
        } else {
            loginButton.isHidden = false
            registerButton.isHidden = false
            onlineOrderButton.isHidden = true
            callButtonTopConstraint?.constant = 109
            callButtonWithConstraint = callButtonWithConstraint.changeMultiplier(multiplier: 1)
            contentViewHeightConstraint = contentViewHeightConstraint.changeMultiplier(multiplier: 0.67)
        }
    }
    private func showAlertForCantOpenURL() {
        let ac = UIAlertController(title: "warning".localized(), message: "this_app_is_not_allowed_to_query_for_scheme_tel".localized(), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok".localized(), style: .default) { (sender) in
            ac.dismiss(animated: true, completion: nil)
        }
        ac.addAction(okAction)
        self.present(ac, animated: true, completion: nil)
    }
}
