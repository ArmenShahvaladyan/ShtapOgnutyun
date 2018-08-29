//
//  UIViewController+Toast.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 6/13/18.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import Foundation
import Toaster

extension UIViewController {
    
    func cancelAllToast() {
        ToastCenter.default.cancelAll()
    }
    
    //MARK: Internal server error
    
    func showToastInternalServerError(vc:UIViewController) {
        vc.showAlertView("internal_server_error".localized(), message: nil, completion: nil)
    }
    
    func showToastForNotInternetConnection() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: Constant.kSINotInternetConectionError).show()
    }
    
    func showToastForLogin() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "please_login_in_order_to_make_online_order".localized()).show()
    }
    //MARK: User - Create/Registration
    
    func showToastAllFieldMustRequired() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "please_fill_all_fields".localized()).show()
    }
    
    func showToastForExistPhoneNumber() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "phone_number_already_registered".localized()).show()
    }
    
    func showToastForExistEmail() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "email_already_exist_in_database".localized()).show()
    }
    
    func showToastForDontExistPhoneNumber() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "phone_number_already_isntRegistered".localized()).show()
    }
    
    func showToastForExistPhoneNumberNotActiveProfile() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "phone_number_already_registered_please_activate_profile_on_login_page").show()
    }
    
    func showToastForENoExistOnTwilio() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "please_try_later".localized()).show()
    }
    
    func showToastForIncorectPhoneNumber() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "phone_number_format_is_incorrect".localized()).show()
    }
    
    func showToastForPasswordFormat() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "password_should_be_6_to_60".localized()).show()
    }
    
    func showToastForFirstnameFormat() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "name_should_be_2_to_60".localized()).show()
    }
    
    func showToastPhoneOrPassword() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "phone_number_format_is_incorrect".localized()).show()
    }
    
    func showToastForFillNameField() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "name_field_is_required_or_incorrect".localized()).show()
    }
    
    func showToastForFillPhoneField() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "phone_number_is_required".localized()).show()
    }
    
    func showToastForFillPasswordField() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "password_should_be_6_to_60".localized()).show()
    }
    
    func showToastForFillConfirmPasswordField() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "passwords_dont_match!".localized()).show()
    }
    
    func showToastForFillEmailield() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "enter_email_with_correct_format!".localized()).show()
    }
    
    func showToastForSuccsesfulySaveSettings() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "changes_successfully_saved".localized()).show()
    }
    
    func showToastAvatarWrongFormat() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "please_try_image_with_formats".localized()).show()
    }
    
    func showToastAvatarWrongSize() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "image_is_too_large_or_too_small".localized()).show()
    }
    
    func showToastExistEmail() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "email_already_exist_in_database".localized()).show()
    }
    
    func showToastWrongCode() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "code_is_incorrect".localized()).show()
    }
    
    func showToastPasswordSuccsesfulySaved() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "passwords_succsesfuly_saved".localized()).show()
    }
    
    func showToastWrongCodeFormat() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "code_is_wrong_format".localized()).show()
    }
    
    func showToastRequiredCode() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "code_is_required".localized()).show()
    }
    
    func showWrongRate() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "rate_values_is_incorrect".localized()).show()
    }
    func showRateSucceed() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "successfully_rated".localized()).show()
    }
    func showCommentLimit() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "comment_should_be_in_1_to_200_range".localized()).show()
    }
    
    func showErrorCreateOrder() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "there_is_no_such_worker_in_database".localized()).show()
    }
    
    func showErrorPendingOrder() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "your_order_already_in_pending_with_this_worker".localized()).show()
    }
    
    func showErrorOrderSuccsefullyCreated() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "your_order_is_confirmed".localized()).show()
    }
    
    func showErrorPhoneNumberNotValidOrEmpty() {
        ToastView.appearance().backgroundColor = UIColor.soOrangeColor
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().font = UIFont.init(name:"ComicSansMSRegular", size: 16)
        ToastView.appearance().bottomOffsetPortrait = 70
        Toast(text: "phone_number_is_empty_or_incorrect".localized()).show()
    }
    
}
