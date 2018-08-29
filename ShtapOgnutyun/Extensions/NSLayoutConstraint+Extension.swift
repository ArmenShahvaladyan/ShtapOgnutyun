//
//  NSLayoutConstraint+Extension.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 5/7/18.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
//    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
//        return NSLayoutConstraint(item: self.firstItem as Any, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
        func changeMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
            let newConstraint = NSLayoutConstraint(
                item: firstItem!,
                attribute: firstAttribute,
                relatedBy: relation,
                toItem: secondItem,
                attribute: secondAttribute,
                multiplier: multiplier,
                constant: constant)
            newConstraint.priority = priority
            
            NSLayoutConstraint.deactivate([self])
            NSLayoutConstraint.activate([newConstraint])
            
            return newConstraint
        }
//    }
}
