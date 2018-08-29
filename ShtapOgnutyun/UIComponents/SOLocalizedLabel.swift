//
//  SILocalizedLabel.swift
//  Smitten
//
//  Created by MacBook on 09/02/2018.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import UIKit

class SOLocalizedLabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.text = self.text?.localized()
    }
}
