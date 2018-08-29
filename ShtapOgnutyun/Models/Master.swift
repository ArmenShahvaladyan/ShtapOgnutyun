//
//  Master.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 5/31/18.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import Foundation
import RealmSwift

class Master: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var rate: Float = 0.0
    @objc dynamic var thumbnailUrl = ""
    @objc dynamic var avatarUrl = ""
    @objc dynamic var name: LocName?
    @objc dynamic var imageData: Data?
    @objc dynamic var thumbnailData: Data?
    
    @objc dynamic var chartRate: ChartRate?
    
    
    convenience init(json: [String: Any]) {
        self.init()
        self.id = json["id"] as? Int ?? 0
        let r = json["rate"] as? String ?? ""
        self.rate = Float(r) ?? 0.0
        self.name = LocName(json: (json["name"] as? [String : Any])!)
        self.avatarUrl = json["avatar"] as? String ?? ""
        self.thumbnailUrl = json["thumbnail"] as? String ?? ""
        if let charter = json["charter"] as? [String: Any]{
            self.chartRate = ChartRate(json: charter)
            var cartVals = [String]()
            charter.forEach { (key,value) in
                cartVals.append((value as? String)!)
            }
            if let maxRate = cartVals.max() {
                chartRate?.maxRate = String(maxRate)
            }
        } else {
            chartRate = ChartRate()
        }
        if let avatarUrl = json["avatar"] as? String {
            if let data = try? Data(contentsOf: URL(string: avatarUrl)!) {
                self.imageData = data
            }
        }
        
        if let thumbnailUrl = json["thumbnail"] as? String {
            if let data = try? Data(contentsOf: URL(string: thumbnailUrl)!) {
                self.thumbnailData = data
            }
        }
    }
}
