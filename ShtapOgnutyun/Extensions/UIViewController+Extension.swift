//
//  UIViewController+Extension.swift
//  ShtapOgnutyun
//
//  Created by Gohar on 25/04/2018.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func getViewControllerWithStoryBoard(sbName: String, vcIndentifier: String) -> UIViewController? {
        let sb = UIStoryboard(name: sbName, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: vcIndentifier)
        return vc
    }
    
    func getInitialViewController(sbName: String) -> UIViewController? {
        let sb = UIStoryboard(name: sbName, bundle: nil)
        let vc = sb.instantiateInitialViewController()
        return vc
    }
    
    func addChildViewController(childVC: UIViewController, toView: UIView, childFrame: CGRect) {
        self.addChildViewController(childVC)
        childVC.view.frame = childFrame
        childVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        UIView.transition(with: toView, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            toView.addSubview(childVC.view)
        }, completion: nil)
        childVC.didMove(toParentViewController: self);
    }
    
    func removeChildViewControllerFromParent() {
        guard parent != nil else {
            return
        }
        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
    }
}
