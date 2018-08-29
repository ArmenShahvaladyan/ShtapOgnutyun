//
//  Validator.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 4/25/18.
//  Copyright © 2018 My Mac. All rights reserved.
//

import Foundation

final class Validator {
    
    //MARK: validate an name for the right format
    func isValidName(name:String?) -> Bool {
        
        guard name != nil else { return false }
        
        if (name?.count)! > 2 && (name?.count)! < 60 {
            return true
        }
        return false
    }
    
    //MARK: validate an userName for the right format
    func isValidUserName(userName:String?) -> Bool {
        
        guard userName != nil else { return false }
        
        let regEx = "^[^<>\\}\\?'!@%#$*`~]{6,15}$"
        
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: userName)
    }
    
    //MARK: validate an email for the right format
    func isValidEmail(email:String?) -> Bool {
        
        guard email != nil else { return false }
        
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }
    
    //MARK: validate an email for the right format
    func isValidPhoneNumber(number:String?) -> Bool {
        
        guard number != nil else { return false }
        
        let regEx = "[+0-9]{12}"
        
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: number)
    }
    
    //MARK: validate an email for the right format
    func isValidCode(code:String?) -> Bool {
        
        guard code != nil else { return false }
        
        let regEx = "[0-9]{4}"
        
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: code)
    }
    
    
    //MARK: validate an password for the right format
    func isValidPassword(passwordString:String?) -> Bool {
        guard passwordString != nil else { return false }
        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        let lenght = passwordString?.count
        let a = passwordString?.replacingOccurrences(of: " ", with: "")
        if lenght! >= 6 && lenght! <= 60 && a != "" {
            return true
        }
        return false

    }
    
    //MARK: validate an password for the right format
    func isValidConfirmPassword(passwordString:String,confirmPasswordString:String) -> Bool {
        let pass = passwordString
        let confirmPass = confirmPasswordString
        return pass == confirmPass
    }
    
}
