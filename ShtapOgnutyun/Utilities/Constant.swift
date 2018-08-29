//
//  Constant.swift
//  ShtapOgnutyun
//
//  Created by Gohar on 25/04/2018.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import Foundation

final class Constant {
    
    //MARK: Not internet Connection error text
    static let kSINotInternetConectionError = "no_internet".localized()
    
    //MARK: App base url
    static let baseUrl:String = "http://37.46.134.33:1835/v1/"
//    static let baseUrl:String = "http://37-46-134-33-lgxmea94sad3.runscope.net/v1/"
    
    //MARK: Device token
//    static let kDeviceToken = UserDefaults.standard.value(forKey: "userDeviceToken") ?? "DeviceToken"
    
    //MARK: Requests endpoints
    static let kCreateUserEndpoint = "users"
    static let kActivateUserEndpoint = "users/activate"
    static let kLoginEndPoint = "users/login"
    static let kGetCurrentUserEndPoint = "users"
    static let kChangeProfileEndPoint = "users/profile"
    static let kForgotPasswordEndPoint = "users/forgot_password"
    static let kLogoutEndPoint = "users/logout"
    static let kDeleteUserEndPoint = "users"
    static let kResentSmsCodeEndPoint = "users/resent"
    static let kSendDeviceTokenEndPoint = "device"
    static let kGetCategoriesEndPoint = "category"
    static let kGetWorkersByCategoriesEndPoint = "workers/category/"
    static let kGetOfficePhoneNumberEndPoint = "users/phone"
    static let kGetOrders = "orders"
    static let kRateEndpoint = "rates/"
    static let kCommentEndpoint = "orders/comment/"

    //MARK: Cell idnetifires
    static let servicesCellID = "servicesCellID"
    static let craftsmanCellID = "craftsmanCellID"
    static let historyCellID = "historyCellID"
    static let bonusCellID = "bonusCellID"
    
    //MARK: User default keys
    static let kToken = "registerToken"
    
}
