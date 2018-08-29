//
//  SIErrorHelper.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 6/4/18.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import UIKit

class SIErrorHelper: NSObject {
    
    func checkCreateUserErrorBy(data:[String: Any], viewController: UIViewController) {
        if let code = data["code"] as? Int {
            switch code {
            case 400:
                viewController.showToastForENoExistOnTwilio()
            case 500:
                viewController.showToastInternalServerError(vc: viewController)
            default:
                break
            }
        }
        if let errorsData = data["errors"] as? [[String: Any]] {
            for dict in errorsData {
                let messageValue = dict["message"] as! String
                let field = dict["field"] as! String
                
                if messageValue == "err.required" {
                    viewController.showToastAllFieldMustRequired()
                    return
                }
                
                if field == "fName" && messageValue == "err.min_length" {
                    viewController.showToastForFirstnameFormat()
                    return
                } else if field == "fName" && messageValue == "err.max_length" {
                    viewController.showToastForFirstnameFormat()
                    return
                } else if field == "email" && messageValue == "err.invalid_email" {
                    viewController.showToastForFillEmailield()
                    return
                }else if field == "email" && messageValue == "err.exist" {
                    viewController.showToastForExistEmail()
                    return
                } else if field == "phone" && messageValue == "err.exist" {
                    viewController.showToastForExistPhoneNumber()
                    return
                } else if field == "phone" && messageValue == "err.not_valid" {
                    viewController.showToastForIncorectPhoneNumber()
                    return
                } else if field == "password" && messageValue == "err.min_length" {
                    viewController.showToastForPasswordFormat()
                    return
                } else if field == "password" && messageValue == "err.max_length" {
                    viewController.showToastForPasswordFormat()
                    return
                }

            }
        }
    }
    
    func checkLoginErrorBy(data:[String: Any], viewController: UIViewController, forbidden: @escaping () -> Void) {
        if let code = data["code"] as? Int {
            switch code {
            case 403:
                forbidden()
            case 404:
                viewController.showToastPhoneOrPassword()
            case 500:
                viewController.showToastInternalServerError(vc: viewController)
            default:
                break
            }
        }
        if let errorsData = data["errors"] as? [[String: Any]] {
            for dict in errorsData {
                let messageValue = dict["message"] as! String
                let field = dict["field"] as! String
                
                if messageValue == "err.required" {
                    viewController.showToastAllFieldMustRequired()
                    return
                }
                
                if messageValue == "err.phone.required" {
                    viewController.showToastAllFieldMustRequired()
                    return
                }
                
                if field == "password" && messageValue == "err.min_length" {
                    viewController.showToastForPasswordFormat()
                    return
                } else if field == "password" && messageValue == "err.max_length" {
                    viewController.showToastForPasswordFormat()
                    return
                } else if field == "phone" && messageValue == "err.not_valid" {
                    viewController.showToastForIncorectPhoneNumber()
                    return
                }
            }
        }
    }
    
    func checkErrorForgotPasswordWith(data:[String: Any], viewController: UIViewController) {
        if let code = data["code"] as? Int {
            switch code {
            case 404:
                viewController.showToastWrongCode()
            case 500:
                viewController.showToastInternalServerError(vc: viewController)
            default:
                break
            }
        }
        if let errorsData = data["errors"] as? [[String: Any]] {
            for dict in errorsData {
                let messageValue = dict["message"] as! String
                let field = dict["field"] as! String
                
                if field == "password" && messageValue == "err.required" {
                    viewController.showErrorPhoneNumberNotValidOrEmpty()
                    return
                } else if field == "password" && messageValue == "err.min_length" {
                    viewController.showToastForPasswordFormat()
                    return
                } else if field == "confirmPassword" && messageValue == "err.min_length" {
                    viewController.showToastForPasswordFormat()
                    return
                } else if field == "confirmPassword" && messageValue == "err.not_match" {
                    viewController.showToastForFillConfirmPasswordField()
                    return
                }
            }
        }
    }
    
    func checkChangeProfileErrorBy(data:[String: Any], viewController: UIViewController) {
        if let code = data["code"] as? Int {
            switch code {
            case 500:
                viewController.showToastInternalServerError(vc: viewController)
            default:
                break
            }
        }
        if let errorsData = data["errors"] as? [[String: Any]] {
            for dict in errorsData {
                let messageValue = dict["message"] as! String
                let field = dict["field"] as! String
                
                if messageValue == "err.required" {
                    viewController.showToastAllFieldMustRequired()
                    return
                }
                
                if field == "fName" && messageValue == "err.min_length" {
                    viewController.showToastForFillNameField()
                    return
                } else if field == "fName" && messageValue == "err.max_length" {
                    viewController.showToastForFillNameField()
                    return
                } else if field == "avatar" && messageValue == "err.type_not_allowed" {
                    viewController.showToastAvatarWrongFormat()
                    return
                } else if field == "avatar" && messageValue == "err.image_too_large" {
                    viewController.showToastAvatarWrongSize()
                    return
                } else if field == "email" && messageValue == "err.exist" {
                    viewController.showToastExistEmail()
                    return
                } else if field == "email" && messageValue == "err.invalid_email" {
                    viewController.showToastForFillEmailield()
                    return
                }
            }
        }
    }
    
    func checkActivateUserProfile(data:[String: Any], viewController: UIViewController) {
        if let code = data["code"] as? Int {
            switch code {
            case 404:
                viewController.showToastWrongCode()
            case 500:
                viewController.showToastInternalServerError(vc: viewController)
            default:
                break
            }
        }
        if let errorsData = data["errors"] as? [[String: Any]] {
            for dict in errorsData {
                let messageValue = dict["message"]as! String
                let field = dict["field"] as! String
                
                if field == "code" && messageValue == "err.wrong_value" {
                    viewController.showToastWrongCode()
                    return
                } else if field == "code" && messageValue == "err.out_of_range" {
                    viewController.showToastWrongCode()
                    return
                }
            }
        }
    }
    
    func checkCreateOrderWith(data:[String: Any], viewController: UIViewController) {
        if let code = data["code"] as? Int {
            switch code {
            case 403:
                viewController.showErrorPendingOrder()
            case 500:
                viewController.showToastInternalServerError(vc: viewController)
            default:
                break
            }
        }
        if let errorsData = data["errors"] as? [[String: Any]] {
            for dict in errorsData {
                let messageValue = dict["message"] as! String
                let field = dict["field"] as! String
                
                if field == "workerId" && messageValue == "err.required" {
                    viewController.showErrorCreateOrder()
                    return
                } else if field == "workerId" && messageValue == "err.wrong_value" {
                    viewController.showErrorCreateOrder()
                    return
                }
            }
        }
    }
    
    func checkErrorResentSmsCodeWith(data:[String: Any], viewController: UIViewController) {
        if let code = data["code"] as? Int {
            switch code {
            case 404:
                viewController.showToastForDontExistPhoneNumber()
            case 500:
                viewController.showToastInternalServerError(vc: viewController)
            default:
                break
            }
        }
        if let errorsData = data["errors"] as? [[String: Any]] {
            for dict in errorsData {
                let messageValue = dict["message"] as! String
                let field = dict["field"] as! String
                
                if field == "phone" && messageValue == "err.required" {
                    viewController.showErrorPhoneNumberNotValidOrEmpty()
                    return
                } else if field == "phone" && messageValue == "err.not_valid" {
                    viewController.showToastForIncorectPhoneNumber()
                    return
                }
            }
        }
    }
    
    func checkLogOutErrorWith(data:[String: Any], viewController: UIViewController) {
        if let code = data["code"] as? Int {
            switch code {
            case 500:
                viewController.showToastInternalServerError(vc: viewController)
            default:
                break
            }
        }
    }
    
    func checkGetCatergorysErrorWith(data:[String: Any], viewController: UIViewController) {
        if let code = data["code"] as? Int {
            switch code {
            case 500:
                viewController.showToastInternalServerError(vc: viewController)
            default:
                break
            }
        }
    }
    
    func checkGetWorkersByCategoriesErrorWith(data:[String: Any], viewController: UIViewController) {
        if let code = data["code"] as? Int {
            switch code {
            case 500:
                viewController.showToastInternalServerError(vc: viewController)
            default:
                break
            }
        }
    }
    
    func checkGetOrdersWith(data:[String: Any], viewController: UIViewController) {
        if let code = data["code"] as? Int {
            switch code {
            case 500:
                viewController.showToastInternalServerError(vc: viewController)
            default:
                break
            }
        }
    }
    
    func checkRateOrderWith(data:[String: Any], viewController: UIViewController) {
        if let code = data["code"] as? Int {
            switch code {
            case 400:
                viewController.showWrongRate()
            case 500:
                viewController.showToastInternalServerError(vc: viewController)
            default:
                break
            }
        }
        
        if let errorsData = data["errors"] as? [[String: Any]] {
            for dict in errorsData {
                let messageValue = dict["message"] as! String
                let field = dict["field"] as! String
                
                if field == "vote" && messageValue == "err.required" {
                    viewController.showWrongRate()
                    return
                } else if field == "orderId" && messageValue == "err.wrong_value" {
                    viewController.showWrongRate()
                    return
                } else if field == "vote" && messageValue == "err.wrong_value" {
                    viewController.showWrongRate()
                    return
                }
            }
        }
    }
    
    func checkCommentOrderWith(data:[String: Any], viewController: UIViewController) {
        if let code = data["code"] as? Int {
            switch code {
            case 500:
                viewController.showToastInternalServerError(vc: viewController)
            default:
                break
            }
        }
        
        if let errorsData = data["errors"] as? [[String: Any]] {
            for dict in errorsData {
                let messageValue = dict["message"] as! String
                let field = dict["field"] as! String
                
                if field == "comment" && messageValue == "err.required" {
                    viewController.showCommentLimit()
                    return
                } else if field == "fName" && messageValue == "err.max_length" {
                    viewController.showCommentLimit()
                    return
                }
            }
        }
    }
    
}

