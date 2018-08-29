//
//  ShadowView.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 4/25/18.
//  Copyright © 2018 My Mac. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    
    //MARK: Lifecycle methods
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 10.0
        self.layer.cornerRadius = 8.0
    }
    
}
