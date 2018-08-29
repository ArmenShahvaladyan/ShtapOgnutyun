//
//  NPLocalizedButton.swift
//  Smitten
//
//  Created by MacBook on 09/02/2018.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import UIKit
import Localize_Swift


class SOLocalizedButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setTitle(self.titleLabel?.text?.localized(), for: .normal)
    }
}
