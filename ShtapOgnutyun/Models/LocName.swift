//
//  LocName.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 5/31/18.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import Foundation
import RealmSwift
import Localize_Swift

class LocName: Object {
    
    @objc private dynamic var en = ""
    @objc private dynamic var ru = ""
    @objc private dynamic var hy = ""
    
    @objc dynamic var value: String {
        let currentLanguage = Localize.currentLanguage()
        switch currentLanguage {
        case "en":
            return self.en
        case "ru":
            return self.ru
        case "hy":
            return self.hy
        default:
            return self.hy
        }
    }
    
    convenience init(json: [String: Any]) {
        self.init()
        self.en = json["en"] as? String ?? ""
        self.ru = json["ru"] as? String ?? ""
        self.hy = json["hy"] as? String ?? ""
    }
}
