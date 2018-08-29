//
//  Order.swift
//  ShtapOgnutyun
//
//  Created by Gohar on 05/06/2018.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import Foundation
import RealmSwift

class Order: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var price = 0
    @objc dynamic var startDate = 0
    @objc dynamic var endDate = 0
    @objc dynamic var vote = ""
    @objc dynamic var isCommented = false
    @objc dynamic var isVoted = false
    @objc dynamic var worker:Master?

    convenience init(json: [String: Any]) {
        self.init()
        self.id = json["id"] as? String ?? ""
        self.price = json["price"] as? Int ?? 0
        self.startDate = json["startDate"] as? Int ?? 0
        self.endDate = json["endDate"] as? Int ?? 0
        self.vote = json["vote"] as? String ?? ""
        self.isCommented = json["isCommented"] as? Bool ?? false
        self.isVoted = json["isVoted"] as? Bool ?? false
        if let worker = json["worker"] as? [String: Any] {
                self.worker = Master.init(json: worker)
        }
    }
}
