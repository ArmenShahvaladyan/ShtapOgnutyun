//
//  LanguageViewController.swift
//  ShtapOgnutyun
//
//  Created by MacBook on 03/05/2018.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import UIKit
import Localize_Swift

class LanguageViewController: BaseViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func chooseLanguage(_ sender: UIButton) {

        UserDefaults.standard.set(true, forKey: "isFirstLaunch")
        switch sender.tag {
        case 1:
            Localize.setCurrentLanguage("hy")
        case 2:
            Localize.setCurrentLanguage("ru")
        case 3:
            Localize.setCurrentLanguage("en")
        default:
            print("no language choosen")
        }
        changeRoot()
    }
    
    private func changeRoot() {
        let storyboard = UIStoryboard(name: "HomeBoard", bundle: nil)
        let homeVC = storyboard.instantiateInitialViewController()
        
        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = homeVC
        UIView.transition(with: window, duration: 0.1, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }
}
