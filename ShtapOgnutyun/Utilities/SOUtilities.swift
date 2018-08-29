//
//  SOUtilities.swift
//  ShtapOgnutyun
//
//  Created by Gohar on 07/06/2018.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import UIKit

final class SOUtilities {
    class var sharedInstance: SOUtilities {
        struct Singleton {
            static let instance = SOUtilities()
        }
        return Singleton.instance
    }
    class func convertDateToString(date: Date, formatter: String) -> String {
        let date_formatter = DateFormatter()
        date_formatter.dateFormat = formatter
        let result = date_formatter.string(from: date)
        
        return result
    }
    class func convertStringToDate(date_str: String, formatter: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        let date = dateFormatter.date(from: date_str)
        return date ?? Date()
    }
}


