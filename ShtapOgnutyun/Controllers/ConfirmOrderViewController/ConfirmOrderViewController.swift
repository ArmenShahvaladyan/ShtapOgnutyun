//
//  ConfirmOrderViewController.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 5/5/18.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import UIKit

class ConfirmOrderViewController: BaseViewController {

    //MARK: Properties

    @IBOutlet private weak var infoView: UIView!
    @IBOutlet private weak var visualEffectView: UIVisualEffectView!
    private var effect: UIVisualEffect!
    
    var willDismisConfirm: (()->())?
    
    //MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        infoView.alpha = 0
    }

    //MARK: Public Api
    
    func animateIn() {
        infoView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.infoView.alpha = 1
            self.infoView.transform = .identity
        }
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.2, animations: {
            self.infoView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.infoView.alpha = 0
            self.visualEffectView.effect = nil
        }) { (finished) in
            if self.willDismisConfirm != nil {
                self.willDismisConfirm!()
            }
        }
    }
    
    //MARK: Public Actions
    
    @IBAction func ok() {
        guard let numberUrl = URL(string: "tel://" + "094059152") else { return }
        
        if UIApplication.shared.canOpenURL(numberUrl) {
            UIApplication.shared.open(numberUrl)
        } else {
            showAlertForCantOpenURL()
        }
        
        let storyboard = UIStoryboard(name: "HomeBoard", bundle: nil)
        let homeVC = storyboard.instantiateInitialViewController()
        
        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = homeVC
        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        animateOut()
    }
    
    @IBAction func cancel() {
        let storyboard = UIStoryboard(name: "HomeBoard", bundle: nil)
        let homeVC = storyboard.instantiateInitialViewController()
        
        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = homeVC
        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        animateOut()
    }
    //MARK: Private functions
    
    private func showAlertForCantOpenURL() {
        let ac = UIAlertController(title: "Warning !", message: "This app is not allowed to query for scheme tel", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (sender) in
            ac.dismiss(animated: true, completion: nil)
        }
        ac.addAction(okAction)
        self.present(ac, animated: true, completion: nil)
    }
    
}
