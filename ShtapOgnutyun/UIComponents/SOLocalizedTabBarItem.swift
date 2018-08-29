//
//  SOLocalizedTabBarItem.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 5/16/18.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import UIKit

class SOLocalizedTabBarItem: UITabBarItem {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = self.title?.localized()
    }
}
