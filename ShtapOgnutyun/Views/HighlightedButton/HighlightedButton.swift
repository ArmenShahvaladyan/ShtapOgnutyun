//
//  HighlightedButton.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 6/22/18.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import UIKit

class HighlightedButton: UIButton {
    
    var label:UILabel?
    
    override var isHighlighted: Bool {
        didSet{
            backgroundColor = isHighlighted ? UIColor.soOrangeColor : UIColor.clear
            label?.textColor = isHighlighted ? UIColor.white : UIColor.soLanguagesButtonColor
        }
    }
    
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
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = self.cornerRadius
            layer.masksToBounds = self.cornerRadius > 0
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setTitle(self.titleLabel?.text?.localized(), for: .normal)
    }
    
    override func draw(_ rect: CGRect) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = (rect.height) / 2
        self.layer.borderWidth = self.borderWidth
        self.layer.borderColor = self.borderColor?.cgColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label = UILabel.init(frame: self.bounds)
        label?.text = self.titleLabel?.text
        label?.font = self.titleLabel?.font
        label?.textAlignment = .center
        label?.textColor = .soLanguagesButtonColor
        self.addSubview(label!)
    }
}

