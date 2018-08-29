//
//  BaseViewController.swift
//  ShtapOgnutyun
//
//  Created by Gohar on 04/06/2018.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.cancelAllToast()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target:nil, action: nil)
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let nvc = viewController as! SONavigationViewController
        if let _ = UserRequestSevice.sharedInstance.currentUser {
            if nvc.viewControllers.last is ResendPasswordCodeViewController {
                nvc.popViewController(animated: false)
            } else if nvc.viewControllers.last is ForgotPasswordViewController {
                nvc.popViewController(animated: false)
                nvc.popViewController(animated: false)
            }
        } else {
            if nvc.viewControllers.last is RateMasterViewController {
                nvc.popViewController(animated: false)
            }
        }
    }
}
