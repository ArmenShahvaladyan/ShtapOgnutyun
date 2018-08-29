//
//  Category.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 5/31/18.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var typeId = 0
    @objc dynamic var imageData: Data?
    @objc dynamic var name: LocName?
    let masters = List<Master>()
    
    convenience init(json: [String: Any]) {
        self.init()
        self.id = json["id"] as? Int ?? 0
        self.typeId = json["typeId"] as? Int ?? 0
        self.name = LocName(json: (json["title"] as? [String : Any])!)
        if let url = json["icon"] as? String {
            if let data = try? Data(contentsOf: URL(string: url)!) {
                self.imageData = data
            }
        }
    }
}
