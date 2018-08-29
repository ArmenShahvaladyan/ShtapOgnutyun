//
//  BorderedTextField.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 4/19/18.
//  Copyright © 2018 My Mac. All rights reserved.
//

import UIKit

class BorderedTextField: UITextField {

    @IBInspectable var borderColor: UIColor? = UIColor.clear {
        didSet {
            layer.borderColor = self.borderColor?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = self.borderWidth
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.white
        self.alpha = 0.5
        self.layer.cornerRadius = (rect.height) / 2
        self.layer.borderWidth = self.borderWidth
        self.layer.borderColor = self.borderColor?.cgColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
    }
    
    private func commonInit() {
        self.text = self.text?.localized()
        self.placeholder = self.placeholder?.localized()
    }

}
