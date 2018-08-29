//
//  UIDevice+Utilities.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 5/8/18.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import UIKit

extension  UIDevice {
    
    static var _isIPhoneX:Int = -1;//in case of -1 it's undefined
    
    class func isIPhoneX() -> Bool {
        if _isIPhoneX >= 0 {
            return _isIPhoneX > 0
        }
        var iphoneX = false
        let screenSize = UIScreen.main.bounds.size
        if screenSize.height == 812 {
            iphoneX = true
        }
        _isIPhoneX = iphoneX ? 1 : 0;
        return iphoneX;
    }
    
    class func isIpad() -> Bool {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        switch (deviceIdiom) {
        case .pad:
            return true
        default:
            return false
        }
    }
}
