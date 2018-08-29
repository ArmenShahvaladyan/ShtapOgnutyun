//
//  DatePickerViewAnimator.swift
//  Smitten
//
//  Created by MacBook on 23/01/2018.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import UIKit

class DatePickerViewAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    var shadeView: UIView?
    var actionTableView: UITableView?
    var dismissing: Bool = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.33
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let animationDuration = self.transitionDuration(using: transitionContext)
        let animationCompletion: ((_ finished: Bool)->())? = {(_ finished: Bool)->() in
            transitionContext.completeTransition(true)
        }
        if self.dismissing {
            let fromController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! DatePickerView
            
            if UIDevice.isIpad() {
                UIView.animate(withDuration: animationDuration, animations: {
                    fromController.shadeView.alpha = 0
                    fromController.pickerContainer?.alpha = 0
                }, completion: animationCompletion)
            } else {
                let frame = fromController.pickerContainer?.frame
                let x = (frame?.origin.x)!
                let y = (frame?.origin.y)! + (frame?.size.height)!
                let w = (frame?.size.width)!
                let h = (frame?.size.height)!
                let nextTableViewFrame = CGRect.init(x: x, y: y, width: w, height: h)
                var sourceTableViewFrame = nextTableViewFrame
                sourceTableViewFrame.origin.y -= sourceTableViewFrame.size.height
                
                fromController.pickerContainer?.frame = sourceTableViewFrame
                UIView.animate(withDuration: animationDuration, animations: {
                    fromController.pickerContainer?.frame = nextTableViewFrame
                    fromController.shadeView.alpha = 0
                }, completion: animationCompletion)
            }
        } else {
            let toController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! DatePickerView
            if (UIDevice.isIpad()) {
                toController.pickerContainer?.alpha = 0;
                UIView.animate(withDuration: animationDuration, animations: {
                    toController.pickerContainer?.alpha = 1
                    toController.shadeView.alpha = 0.3;
                }, completion: animationCompletion)
            } else {
                let nextTableViewFrame = toController.pickerContainer?.frame
                var sourceTableViewFrame = nextTableViewFrame!
                sourceTableViewFrame.origin.y += sourceTableViewFrame.size.height
                toController.pickerContainer?.frame = sourceTableViewFrame
                toController.pickerContainer?.alpha = 1
                
                UIView.animate(withDuration: animationDuration, animations: {
                    toController.pickerContainer?.frame = nextTableViewFrame!
                    toController.shadeView.alpha = 0.3;
                }, completion: animationCompletion)
            }
            toController.view.frame = containerView.bounds;
            containerView.addSubview(toController.view)
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.dismissing = true
        return self
    }
}
