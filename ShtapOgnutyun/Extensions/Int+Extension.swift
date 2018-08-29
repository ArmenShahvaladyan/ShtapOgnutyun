//
//  Int+Extension.swift
//  ShtapOgnutyun
//
//  Created by Gohar on 07/06/2018.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import Foundation

extension Int {
    static func milisecToString(miliseconds: Int) -> String {
        let dateVar = Date.init(timeIntervalSinceNow: TimeInterval(miliseconds)/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm"
        return dateFormatter.string(from: dateVar)
    }
}
