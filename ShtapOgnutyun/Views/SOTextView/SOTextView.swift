//
//  SOTextView.swift
//  ShtapOgnutyun
//
//  Created by Gohar on 19/06/2018.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import UIKit

class SOTextView: UITextView {
    
    var placeHolder: String? {
        willSet {
            lbl?.text = newValue
        }
    }
    
    var lbl: UILabel?
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.white
        createPlaceHolderLabel()
    }
    
    //MARK: other methods
    
    func createPlaceHolderLabel() {
        guard lbl == nil else {
            return
        }
        let font = self.font
        lbl = UILabel.init()
        lbl?.textColor = UIColor.gray
        lbl?.text = placeHolder
        lbl?.font = font
        lbl?.textAlignment = .left
        lbl?.numberOfLines = 0
        lbl?.preferredMaxLayoutWidth = self.frame.size.width - 20
        lbl?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lbl!)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(8)-[lbl]", options: [], metrics: nil, views: ["lbl":lbl!]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(8)-[lbl]-(10)-|", options: [], metrics: nil, views: ["lbl":lbl!]))
    }
}
