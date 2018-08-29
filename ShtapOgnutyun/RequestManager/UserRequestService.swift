//
//  UserRequestService.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 5/29/18.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import Localize_Swift

class UserRequestSevice {
    
    static var instance:UserRequestSevice? = nil
    
    class var sharedInstance: UserRequestSevice {
        if instance == nil {
            instance = UserRequestSevice()
        }
        return instance!
    }
    
    //MARK: Token for request
    var token: String?  {
        set {
            
        }
        get {
            if currentUser?.token == nil {
                return UserDefaults.standard.value(forKey: Constant.kToken) as? String
            } else {
                return currentUser?.token
            }
        }
    }
    
    //MARK: Header for request
    var headerJSON: HTTPHeaders {
        get {
            if self.token != nil {
                return ["Authorization": "\("Bearer ")\(self.token!)","Content-type": "application/json"]
            } else {
                return ["Content-type": "application/json"]
            }
        }
    }
    
    var createProfileHeaderJSON: HTTPHeaders {
        get {
            return ["Content-type": "multipart/form-data"]
        }
    }
    
    var profileHeaderJSON: HTTPHeaders {
        get {
            return ["Content-type": "multipart/form-data","Authorization": "\("Bearer ")\(self.token!)"]
        }
    }
    
    //MARK: App current user
    var currentUser: User? {
        
        set(newuser) {
            
        }
        get {
            let cUser = uiRealm.objects(User.self).filter("isUserLogged == true")
            return cUser.last
        }
        
    }
    
    //MARK: Login and registre requests
    
    func createUser(userParams: [String:Any] , succsesBlock: @escaping ([String: Any] ) -> Void , failerBlock: @escaping (Any) -> Void)  {
        AlamofireWrapper.uploadRequest(Constant.kCreateUserEndpoint, imageData: nil, params: userParams, headers: createProfileHeaderJSON, success: { (succses) in
            succsesBlock(succses as! [String : Any])
        }) { (error) in
            failerBlock(error)
        }
    }
    
    func activateUserProfile(code:String , succsesBlock: @escaping (User) -> Void , failerBlock: @escaping (Any) -> Void) {
        AlamofireWrapper.postRequest(Constant.kActivateUserEndpoint, params: ["code": code], headers: headerJSON, success: { (succses) in
            if let succsesData = succses as? [String: Any] {
                if let data = succsesData["data"] as? [String: Any] {
                    let userData = data["user"] as? [String: Any]
                    let user = User.init(json: userData!, token: self.token!)
                    user.isUserLogged = true
                    RealmWrapper.sharedInstance.addObjectInRealmDB(user)
                    UserDefaults.standard.removeObject(forKey: Constant.kToken)
                    succsesBlock(user)
                }
            }
        }) { (errorData) in
            failerBlock(errorData)
        }
    }
    
    func loginProfile(loginData:[String:Any], succsesBlock: @escaping (User) -> Void , failerBlock: @escaping (Any) -> Void) {
        AlamofireWrapper.postRequest(Constant.kLoginEndPoint, params:loginData, headers: headerJSON, success: { (succses) in
            
            if let json  =  succses as? [String: Any] {
                if let data = json["data"] as? [String: Any] {
                    if let userData = data["user"] as? [String: Any] {
                        let user = User.init(json:  userData, token: data["token"] as? String ?? "")
                        user.isUserLogged = true
                        Localize.setCurrentLanguage(user.lang)
                        RealmWrapper.sharedInstance.addObjectInRealmDB(user)
                        succsesBlock(user)
                        //                        self.sendDeviceToken(succsesBlock: { (succses) in
                        //                            succsesBlock(user)
                        //                        }) { (error) in
                        //                            debugPrint(error)
                        //                        }
                    }
                }
            }
            
        }) { (errorData) in
            failerBlock(errorData)
        }
    }
    
    func resentSmsCode(phoneNumber: String , succsesBlock: @escaping (Any) -> Void , failerBlock: @escaping (Any) -> Void)  {
        AlamofireWrapper.postRequest(Constant.kResentSmsCodeEndPoint, params: ["phone" : phoneNumber], headers: headerJSON, success: { (succses) in
            succsesBlock(succses)
        }) { (errorData) in
            failerBlock(errorData)
        }
    }
    
    func forgotPassword(userParams: [String:Any] , succsesBlock: @escaping () -> Void , failerBlock: @escaping (Any) -> Void){
        AlamofireWrapper.postRequest(Constant.kForgotPasswordEndPoint, params: userParams, success: { (succses) in
            succsesBlock()
        }) { (errorData) in
            failerBlock(errorData)
        }
    }
    
    func logOut(token: String ,succsesBlock: @escaping (Any) -> Void , failerBlock: @escaping (Any) -> Void) {
        AlamofireWrapper.postRequesta(Constant.kLogoutEndPoint, params: ["token" : token], headers: headerJSON, success: { (succses) in
            succsesBlock(succses)
        }) { (errorData) in
            failerBlock(errorData)
        }
    }
    
    
    func deleteProfile(succsesBlock: @escaping (Any) -> Void, failerBlock:  @escaping (Any) -> Void) {
        AlamofireWrapper.deleteRequest(Constant.kDeleteUserEndPoint, params: nil, headers: headerJSON, success: { (succses) in
            succsesBlock(succses)
        }) { (errorData) in
            failerBlock(errorData)
        }
    }
    
    func getCurrentUser(succsesBlock: @escaping (Any) -> Void, failerBlock:  @escaping (Any) -> Void) {
        AlamofireWrapper.getRequest(Constant.kGetCurrentUserEndPoint, params: nil, headers: headerJSON, success: { (succses) in
            if let succsesData = succses as? [String: Any] {
                if let data = succsesData["data"] as? [String: Any] {
                    let user = User.init(json:  data, token: nil)
                    if self.currentUser?.phone == user.phone {
                        user.isUserLogged = true
                    }
                    succsesBlock(user)
                } else {
                    failerBlock("no user data")
                }
            }
        }) { (errorData) in
            failerBlock(errorData)
        }
    }
    
    func changeProfile(params:[String:Any]? ,imageData :Data? , succsesBlock: @escaping (Any) -> Void , failerBlock: @escaping (Any) -> Void) {
        AlamofireWrapper.uploadRequest(Constant.kChangeProfileEndPoint, imageData: nil, params: params, headers: profileHeaderJSON, success: { (succses) in
            if let succsesData = succses as? [String: Any] {
                if let data = succsesData["data"] as? [String: Any] {
                    let updatedUser = User.init(json: data, token: self.currentUser?.token)
                    updatedUser.isUserLogged = true
                    self.currentUser?.update(updatedUser)
                    succsesBlock(succses)
                }
            }
        }) { (error) in
            failerBlock(error)
        }
    }
    
    //MARK: Send device token
    
    //    func sendDeviceToken(succsesBlock: @escaping(Any) -> Void , failerBlock : @escaping (Any) -> Void) {
    //        AlamofireWrapper.postRequest("\(Constants.kSendDeviceTokenEndPoint)\(Constants.kDeviceToken)", params: nil, headers: headerJSON, success: { (succses) in
    //            succsesBlock(succses)
    //        }) { (error) in
    //            failerBlock(error)
    //        }
    //    }
    
    
    func deleteUser(succsesBlock: @escaping(Any) -> Void , failerBlock : @escaping (Any) -> Void) {
        AlamofireWrapper.deleteRequest(Constant.kCreateUserEndpoint, params: nil, headers: headerJSON, success: { succses in
            succsesBlock(succses)
        }) { (error) in
            failerBlock(error)
        }
    }
    
    //MARK: Get Categories
    
    func getCategories(succsesBlock: @escaping () -> Void, failerBlock:  @escaping (Any) -> Void) {
        AlamofireWrapper.getRequest(Constant.kGetCategoriesEndPoint, params: nil, headers: headerJSON, success: { (succses) in
            if let succsesData = succses as? [String: Any] {
                if let data = succsesData["data"] as? [[String: Any]] {
                    RealmWrapper.sharedInstance.deleteObjectsOfModelInRealmDB(Category.self)
                    for json in data {
                        let category = Category(json: json)
                        RealmWrapper.sharedInstance.addObjectInRealmDB(category)
                    }
                    succsesBlock()
                } else {
                    failerBlock("no user data")
                }
            }
        }) { (errorData) in
            failerBlock(errorData)
        }
    }
    
    //MARK: Get office phone number
    
    func getOfficePhoneNumber(succsesBlock: @escaping () -> Void, failerBlock:  @escaping (Any) -> Void) {
        AlamofireWrapper.getRequest(Constant.kGetOfficePhoneNumberEndPoint, params: nil, headers: headerJSON, success: { (succses) in
            if let succsesData = succses as? [String: Any] {
                if let data = succsesData["data"] as? [String: Any] {
                    if let phoneNumber  = data["phone"] as? String {
                        UserDefaults.standard.set(phoneNumber, forKey: "officePhoneNumber")
                    }
                }
            }
        }) { (errorData) in
            failerBlock(errorData)
        }
    }
    
    //MARK: Get Categories
    
    func getWorkersByCategories(catId:Int ,succsesBlock: @escaping (_ masters: [Master]) -> Void, failerBlock:  @escaping (Any) -> Void) {
        AlamofireWrapper.getRequest(Constant.kGetWorkersByCategoriesEndPoint + "\(catId)?expand=charter", params: nil, headers: headerJSON, success: { (succses) in
            if let succsesData = succses as? [String: Any] {
                let masters = [Master]()
                if let data = succsesData["data"] as? [[String: Any]] {
                    var masters = [Master]()
                    for master in data {
                        let master = Master.init(json: master)
                        masters.append(master)
                    }
                    succsesBlock(masters)
                } else {
                    succsesBlock(masters)
                }
            }
        }) { (errorData) in
            failerBlock(errorData)
        }
    }
    
    // MARK: GetMaxValue
    
    func minMax(array: [Int]) -> (min: Int, max: Int) {
        var currentMin = array[0]
        var currentMax = array[0]
        for value in array[1..<array.count] {
            if value < currentMin {
                currentMin = value
            } else if value > currentMax {
                currentMax = value
            }
        }
        return (currentMin, currentMax)
    }
    
    
    // MARK: Order
    // Order - Get current user order list
    // Endpoint - /orders
    func getOrders(succsesBlock: @escaping ([Order]) -> Void, failer:  @escaping (Any?) -> Void) {
        AlamofireWrapper.getRequest(Constant.kGetOrders, params: nil, headers: headerJSON, success: { (succses) in
            if let succsesData = succses as? [String: Any] {
                var orders = [Order]()
                if let data = succsesData["data"] as? [String: Any] {
                    RealmWrapper.sharedInstance.updateObjectsWithPrinaryKey {
                        UserRequestSevice.sharedInstance.currentUser?.bonus = data["bonus"] as! String
                    }
                    if let ordersArray = data["orders"] as? [[String: Any]] {
                        RealmWrapper.sharedInstance.deleteObjectsOfModelInRealmDB(Order.self)
                        for json in ordersArray {
                            let order = Order(json: json)
                            orders.append(order)
                            RealmWrapper.sharedInstance.addObjectInRealmDB(order)
                        }
                    }
                    succsesBlock(orders)
                } else {
                    succsesBlock(orders)
                }
            }
        }) { (errorData) in
            failer(errorData)
        }
    }
    
    // MARK: Rate Order
    // Rate - Create rate order
    // /rates/{orderId}
    // parameter : vote
    
    func rateOrder(orderID: String, vote: Int, succsesBlock: @escaping () -> Void, failer:  @escaping (Any?) -> Void){
        let params = ["vote":vote]
        AlamofireWrapper.postRequest(Constant.kRateEndpoint + "\(orderID)", params: params, headers: headerJSON, success: { response in
            succsesBlock()
        }) { error in
            failer(error)
        }
    }
    
    // MARK: Comment Order
    // Order - Create order comment
    // /orders/comment/{orderId}
    // Parameter - comment: String
    // Mandatory value - Size range: 1...200
    
    func commentOrder(orderID: String, comment: String, succsesBlock: @escaping () -> Void, failer:  @escaping (Any?) -> Void) {
        let params = ["comment":comment]
        AlamofireWrapper.postRequest(Constant.kCommentEndpoint + "\(orderID)", params: params,  headers: headerJSON, success: { response in
            succsesBlock()
        }) { error in
            failer(error)
        }
    }
    
    func createOrderWith(workerid id: Int, succsesBlock: @escaping () -> Void, failer:  @escaping (Any?) -> Void) {
        AlamofireWrapper.postRequest(Constant.kGetOrders, params: ["workerId": id] , headers: headerJSON, success: { response in
            succsesBlock()
        }) { error in
            failer(error)
        }
    }
    
    func sendOrderWith(comment c: String, succsesBlock: @escaping () -> Void, failer:  @escaping (Any?) -> Void) {
        AlamofireWrapper.postRequest(Constant.kGetOrders, params: ["comment": c] , headers: headerJSON, success: { response in
            succsesBlock()
        }) { error in
            failer(error)
        }
    }
    
}

