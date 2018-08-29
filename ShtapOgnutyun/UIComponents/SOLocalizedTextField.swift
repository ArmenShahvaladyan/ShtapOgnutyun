//
//  SILocalizedTextField.swift
//  Smitten
//
//  Created by MacBook on 09/02/2018.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import UIKit

class SOLocalizedTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
    }
    
    private func commonInit() {
        self.text = self.text?.localized()
        self.placeholder = self.placeholder?.localized()
    }
    
    
}
