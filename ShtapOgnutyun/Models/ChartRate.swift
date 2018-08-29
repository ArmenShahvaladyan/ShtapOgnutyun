//
//  ChartRate.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 5/31/18.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import Foundation
import RealmSwift

class ChartRate: Object {
    
    @objc dynamic var poor = "0"
    @objc dynamic var bellowAverage = "0"
    @objc dynamic var average = "0"
    @objc dynamic var good = "0"
    @objc dynamic var excellent = "0"
    @objc dynamic var maxRate = "0"
    
    convenience init(json: [String: Any]) {
        self.init()
        self.poor = json["1"] as? String ?? "0"
        self.bellowAverage = json["2"] as? String ?? "0"
        self.average = json["3"] as? String ?? "0"
        self.good = json["4"] as? String ?? "0"
        self.excellent = json["5"] as? String ?? "0"
    }
    
    subscript(key: String) -> Int {
        return self.value(forKey: key) as! Int
    }
    
}
