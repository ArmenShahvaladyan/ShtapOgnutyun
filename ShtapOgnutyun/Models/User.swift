//
//  User.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 5/29/18.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    
    @objc dynamic var token = ""
    @objc dynamic var id = ""
    @objc dynamic var fName = ""
    @objc dynamic var phone = ""
    @objc dynamic var email = ""
    @objc dynamic var bonus = ""
    @objc dynamic var age:Int = 0
    @objc dynamic var avatar = ""
    @objc dynamic var thumbnail = ""
    @objc dynamic var lang = ""
    @objc dynamic var isUserLogged = false

    convenience init(json: [String: Any]?,token:String?) {
        self.init()
        self.id = json?["id"] as? String ?? ""
        self.fName = json?["fName"] as? String ?? ""
        self.lang = json?["lang"] as? String ?? ""
        self.phone = json?["phone"] as? String ?? ""
        self.email = json?["email"] as? String ?? ""
        self.age = json?["age"] as? Int ?? 0
        self.avatar = json?["avatar"] as? String ?? ""
        self.thumbnail = json?["thumbnail"] as? String ?? ""
        self.token = token ?? ""
    }
    
    func update(_ updatedUser: User){
        RealmWrapper.sharedInstance.updateObjectsWithPrinaryKey {
            self.id = updatedUser.id
            self.fName = updatedUser.fName
            self.phone = updatedUser.phone
            self.lang = updatedUser.lang
            self.email = updatedUser.email
            self.bonus = updatedUser.bonus
            self.age = updatedUser.age
            self.avatar = updatedUser.avatar
            self.thumbnail = updatedUser.thumbnail
        }
    }
}
