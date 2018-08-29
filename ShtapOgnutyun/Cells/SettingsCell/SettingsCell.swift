//
//  SettingsCell.swift
//  ShtapOgnutyun
//
//  Created by MacBook on 02/02/2018.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import UIKit
import Localize_Swift

@objc protocol SettingsCellDelegate {
    @objc optional func onSelectLanguageCell()
}

class SettingsCell: UITableViewCell , UITextFieldDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var editingTextField: UITextField!
    
    // MARK: Variables
    var onClickTF: ((_ tfRect: CGRect)->())?
    var onClickTFa: ((_ tapGesture: UITapGestureRecognizer)->())?
    weak var settingsDelegate:SettingsCellDelegate?
    let currentUser = UserRequestSevice.sharedInstance.currentUser
    
    //MARK: Lifecycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapEditingTextField))
        editingTextField.addGestureRecognizer(tapGesture)
    }
    
    func setKeyboardTypes(title t: String) {
        let str = t.localized()
        title.text = str
        switch t {
        case "email_address":
            editingTextField.keyboardType = .emailAddress
        default:
            break
        }
    }
    
    func setLabelLanguage(languages: String) -> String {
        
        switch languages {
        case "en":
            return "English"
        case "ru":
            return "Russian"
        case "hy":
            return "Armenian"
        default:
            break
        }
        return "Armenian"
    }
    
    func setUserSettings(user:User?) {
        let currentLang = Localize.currentLanguage()
        if let loggedUser = user?.isUserLogged {
            if !loggedUser {
                if title.text?.localized() == "language".localized() {
                    self.title.textColor = UIColor.soOrangeColor
                } else {
                    self.title.textColor = UIColor.soSettingsPlaceholderColor
                }
            } else {
                self.title.textColor = UIColor.soOrangeColor
            }
            switch title.text?.localized() {
            case "full_name".localized():
                editingTextField.text = user?.fName
            case "email_address".localized():
                editingTextField.text = user?.email
            case "language".localized():
                editingTextField.text = setLabelLanguage(languages:currentLang)
            default:
                break
            }
          
        }
    }
    
    @objc func tapEditingTextField(tap: UITapGestureRecognizer) {
        let view = tap.view as? UITextField;
        
        if onClickTFa != nil {
            onClickTFa!(tap)
        }
        
        if title.text?.localized() == "language".localized() {
            settingsDelegate?.onSelectLanguageCell!()
        } else {
            view?.becomeFirstResponder()
        }
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if onClickTF != nil {
            onClickTF!(editingTextField.frame)
        }
    }
    
    //MARK: UITapGestureRecognizer
    
    @objc func handleTap(tap: UITapGestureRecognizer) {
        if onClickTF != nil {
            onClickTF!(editingTextField.frame)
        }
    }
}
