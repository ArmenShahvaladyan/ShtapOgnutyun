//
//  UIViewController+SIUIAlertViewController.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 6/13/18.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    //MARK: AlertView
    
    func showAlertView(_ title:String? , message: String?, completion:((_ finish:Bool)->Void)?) -> Void {
        let _self = self;
        
        let alertView = UIAlertController(title: title, message:message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertView.addAction(UIAlertAction(title: "cancel".localized(),style: UIAlertActionStyle.cancel,
                                          handler: {(alert: UIAlertAction!) in
                                            if completion != nil {
                                                completion!(true)
                                            }
        }))
        
        _self.present(alertView, animated: true, completion: nil)
    }
    
    
    func showAlertViewController(_ title:String? , message: String?, otherButtonTitles :[String], cancelButtonTitle:String?, destructiveButtonTitle: String?, actionHandler :((_ action: String)->Void)? )-> Void {
        
        let _self = self;
        
        let alertView = UIAlertController(title: title, message:message, preferredStyle: UIAlertControllerStyle.alert)
        
        let subView = alertView.view.subviews.first!
        let alertContentView = subView.subviews.first!
        alertContentView.backgroundColor = UIColor.clear
        alertContentView.layer.cornerRadius = 5
        
        let attributedString = NSAttributedString(string: title!, attributes: [NSAttributedStringKey.foregroundColor : UIColor.black])
        alertView.setValue(attributedString, forKey: "attributedTitle")
        
        if !otherButtonTitles.isEmpty {
            for otherButtonTitle in otherButtonTitles {
                alertView.addAction(UIAlertAction(title: otherButtonTitle,style: UIAlertActionStyle.destructive,                handler: {(alert: UIAlertAction!) in
                    
                    actionHandler!(otherButtonTitle)
                    debugPrint(otherButtonTitle)
                    alertView.dismiss(animated: true, completion: nil)
                }))
            }
            
        }
        
        if cancelButtonTitle != nil {
            
            alertView.addAction(UIAlertAction(title: cancelButtonTitle,style: UIAlertActionStyle.cancel,                handler: {(alert: UIAlertAction!) in
                alertView.dismiss(animated: true, completion: nil)
            }))
        }
        
        if destructiveButtonTitle != nil {
            alertView.addAction(UIAlertAction(title: destructiveButtonTitle,style: UIAlertActionStyle.destructive,
                                              handler: {(alert: UIAlertAction!) in
                                                actionHandler!(destructiveButtonTitle!)
                                                alertView.dismiss(animated: true, completion: nil)
            }))
        }
        _self.present(alertView, animated: true, completion: nil)
    }
    
    func showActionSheetInController(_ sender:UIView, title:String? , message: String?, otherButtonTitles :[String], cancelButtonTitle:String?, destructiveButtonTitle: String?, actionHandler :((_ action: String)->Void)? )-> Void {
        
        let _self = self;
        
        let alertView = UIAlertController(title: title, message:message, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        if !otherButtonTitles.isEmpty {
            for otherButtonTitle in otherButtonTitles {
                alertView.addAction(UIAlertAction(title: otherButtonTitle,style: UIAlertActionStyle.default,                handler: {(alert: UIAlertAction!) in
                    actionHandler!(otherButtonTitle)
                    alertView.dismiss(animated: true, completion: nil)
                }))
            }
        }
        
        if cancelButtonTitle != nil {
            alertView.addAction(UIAlertAction(title: cancelButtonTitle,style: UIAlertActionStyle.cancel, handler: {(alert: UIAlertAction!) in
                //                actionHandler!(action: cancelButtonTitle!)
                alertView.dismiss(animated: true, completion: nil)
            }))
        }
        
        if destructiveButtonTitle != nil {
            alertView.addAction(UIAlertAction(title: destructiveButtonTitle,style: UIAlertActionStyle.destructive, handler: {(alert: UIAlertAction!) in
                alertView.dismiss(animated: true, completion: nil)
            }))
        }
        
        if ( UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad ) {
            
            if let currentPopoverpresentioncontroller = alertView.popoverPresentationController {
                currentPopoverpresentioncontroller.sourceView = sender
                currentPopoverpresentioncontroller.sourceRect = sender.frame
                
                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.down
                _self.present(alertView, animated: true, completion: nil)
            }
        } else {
            _self.present(alertView, animated: true, completion: nil)
        }
    }
    
    func showActivateAlertWith(phoneNumber:String ,sendAction: @escaping (_ code: String) -> Void) {
        let alertController = UIAlertController(title: "please_wait_for_code".localized(), message: "", preferredStyle: .alert)
        alertController.view.backgroundColor = UIColor.clear
        alertController.addAction(UIAlertAction(title: "Ok".localized(), style: .default, handler: { alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            sendAction(textField.text!)
        }))
        
        alertController.addAction(UIAlertAction(title: "resend".localized(), style: .default, handler: { alert -> Void in
            SOIndicator.showInView((self.parent?.view)!)
            UserRequestSevice.sharedInstance.resentSmsCode(phoneNumber: phoneNumber, succsesBlock: { (responce) in
                SOIndicator.hide()
                if let responceData = responce as? [String: Any] {
                    if let data = responceData["data"] as? [String: Any] {
                        let token = data["token"] as? String
                        UserDefaults.standard.set(token, forKey: Constant.kToken)
                        UserDefaults.standard.synchronize()
                        self.showActivateAlertWith(phoneNumber: phoneNumber, sendAction: { [weak self] code in
                            self?.activateProfile(code: code, succses: {
//                                completion()
                            }, failure: { error in
//                                failure(error)
                            })
                        })
                    }
                }
            }, failerBlock: { (error) in
                SOIndicator.hide()
                if error as? String == Constant.kSINotInternetConectionError {
                    self.showToastForNotInternetConnection()
                }
                if let errorData = error as? [String :Any] {
                    SIErrorHelper().checkErrorResentSmsCodeWith(data: errorData, viewController: self)
                }
            })
        }))
        
        alertController.addAction(UIAlertAction(title: "cancel".localized(), style: .cancel, handler: nil))
        alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            textField.placeholder = "code".localized()
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    func activateProfile(code:String, succses: @escaping () -> Void, failure: @escaping (_ error: Any?) -> Void) {
        SOIndicator.showInView((self.parent?.view)!)
        UserRequestSevice.sharedInstance.activateUserProfile(code: code, succsesBlock: { user in
            SOIndicator.hide()
            succses()
        }) { (error) in
            SOIndicator.hide()
            failure(error)
        }
    }
    
    func showAlertForActivateProfileWith(phoneNumber:String, completion: @escaping () -> Void, failure: @escaping (Any?) -> Void) {
        self.showAlertViewController("please_activate_your_profile".localized(), message: nil, otherButtonTitles: ["activation".localized()] , cancelButtonTitle: "cancel".localized(), destructiveButtonTitle: nil) { (action) in
            if action == "activation".localized() {
                SOIndicator.showInView((self.parent?.view)!)
                UserRequestSevice.sharedInstance.resentSmsCode(phoneNumber: phoneNumber, succsesBlock: { (responce) in
                    SOIndicator.hide()
                    if let responceData = responce as? [String: Any] {
                        if let data = responceData["data"] as? [String: Any] {
                            let token = data["token"] as? String
                            UserDefaults.standard.set(token, forKey: Constant.kToken)
                            UserDefaults.standard.synchronize()
                            self.showActivateAlertWith(phoneNumber: phoneNumber, sendAction: { [weak self] code in
                                self?.activateProfile(code: code, succses: {
                                    completion()
                                }, failure: { error in
                                    failure(error)
                                })
                            })
                        }
                    }
                }, failerBlock: { (error) in
                    SOIndicator.hide()
                    if error as? String == Constant.kSINotInternetConectionError {
                        self.showToastForNotInternetConnection()
                    }
                    if let errorData = error as? [String :Any] {
                        SIErrorHelper().checkErrorResentSmsCodeWith(data: errorData, viewController: self)
                    }
                })
            }
        }
    }
}
