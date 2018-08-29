//
//  SONavigationViewController.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 5/8/18.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import UIKit

class SONavigationViewController: UINavigationController {
    
    var navBarIMG: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.title = " "
        if UIDevice.isIpad() {
            self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white,
                                                      NSAttributedStringKey.font: UIFont.systemFont(ofSize: 27)]
        } else {
            self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white,
                                                      NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)]
        }
        
        setNavigationBar()
    }
    
    func setNavigationBar() {
        
        if UIDevice.isIpad() {
            navBarIMG = UIImage(named: "nav_bar-bg")!.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        } else {
            navBarIMG = UIImage(named: "nav_bariPhone")!.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        self.navigationBar.setBackgroundImage(navBarIMG, for: .default)
        self.navigationBar.layer.masksToBounds = false
        self.navigationBar.layer.shadowColor = UIColor.darkGray.cgColor
        self.navigationBar.layer.shadowOpacity = 0.8
        self.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        self.navigationBar.layer.shadowRadius = 2
    }
}
