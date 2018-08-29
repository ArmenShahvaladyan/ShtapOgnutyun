//
//  SettingsViewController.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 5/2/18.
//  Copyright © 2018 My Mac. All rights reserved.
//

import UIKit
import Localize_Swift

class SettingsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource , SettingsCellDelegate , DatePickerViewDelegate, DataPickerViewDataSource{
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variables
    let settingTitles = ["full_name" ,"email_address", "language"]
    var settingsData = [String: Any]()
    private var selectedRect: CGRect?
    var editOrNot = false
    var languagesTextField:UITextField?
    var languages = ["Armenian" , "Russian", "English"]
    var logOutBarItem = UIBarButtonItem()
    var editBarItem = UIBarButtonItem()
    var loading: SOIndicator?
    var isUserLogged:Bool {
        return UserRequestSevice.sharedInstance.currentUser?.isUserLogged ?? false
    }
    var currentUser:User {
        return UserRequestSevice.sharedInstance.currentUser ?? User()
    }
    
    //MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()        
        tableView.layer.cornerRadius = 8
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tableView.register(UINib.init(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "settingsCellID")
        self.title = "settings".localized()
        loading = SOIndicator(view: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(closeKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        addItemsOnNavigation()
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden), name: .UIKeyboardWillHide, object: nil)
        self.tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
    }
    
    @objc func setText(){
        self.title = "settings".localized()
        logOutBarItem.title = "logOut".localized()
        let homeVC = self.tabBarController?.viewControllers![0]
        homeVC?.tabBarItem.title = "home".localized()
        let historyVC = self.tabBarController?.viewControllers![1]
        historyVC?.tabBarItem.title = "history".localized()
        let settingsVC = self.tabBarController?.viewControllers![2]
        settingsVC?.tabBarItem.title = "settings".localized()
    }
    
    //MARK: Keyboard notifications
    
    @objc func keyboardWillShow(notification: Notification) {
        if let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
            changeTablePosition(frame.cgRectValue.height, completion: nil)
        }
    }
    
    @objc func keyboardWillHidden(notification: Notification) {
        self.tableView.contentInset.bottom = 10
        self.tableView.scrollIndicatorInsets.bottom = 10
    }
    
    func changeTablePosition(_ height: CGFloat, completion: (() -> Void)?) {
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, height, 0.0)
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
        
        var aRect = self.view.frame
        aRect.size.height -= height
        
        if selectedRect != nil {
            if  !(aRect.contains((selectedRect?.origin)!)) {
                let scrollPoint = CGPoint(x: 0.0, y: (selectedRect?.origin.y)! - height)
                tableView.setContentOffset(scrollPoint, animated: true)
            }
        }
        completion?()
    }
    
    //MARK: Validations
    
    private func validateFields() -> Bool {
        
        let object = settingTitles
        for j in 0..<object.count {
            //                 te titles i vor indexne i - n
            let indexPath = IndexPath.init(row: j, section: 0 )
            let cell = tableView.cellForRow(at: indexPath) as? SettingsCell
            
            if cell?.title.text == self.settingTitles[indexPath.row].localized() {
                if cell?.title.text == "full_name".localized() {
                    if cell?.editingTextField.text != "" && Validator().isValidName(name: cell?.editingTextField.text){
                        settingsData["User[fName]"] = cell?.editingTextField.text
                        continue
                    } else {
                        self.showToastForFirstnameFormat()
                        return false
                    }
                } else  if cell?.title.text == "email_address".localized() {
                    settingsData["User[email]"] = cell?.editingTextField.text
                    continue
                } else  if cell?.title.text == "language".localized() {
                    if  cell?.editingTextField.text != "" {
                        settingsData["User[lang]"] = setLanguage(languages: (cell?.editingTextField.text)!)
                        continue
                    } else {
                        return false
                    }
                }
            }
            
        }
        return true
    }
    
    //MARK: Set App language
    
    func setLanguage(languages: String) -> String {
        switch languages {
        case "English":
            return "en"
        case "Russian":
            return "ru"
        case "Armenian":
            return "hy"
        default:
            break
        }
        return "hy"
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
    
    @objc func closeKeyboard() {
        self.tableView.contentInset.bottom = 10
        self.tableView.scrollIndicatorInsets.bottom = 10
        self.view.endEditing(true)
    }
    
    @objc func logOut() {
        RealmWrapper.sharedInstance.deleteObjectFromRealmDB(self.currentUser)
        self.tableView.reloadData()
        self.logOutBarItem.isEnabled = false
        self.editBarItem.isEnabled = false
    }
    
    @objc func edit() {
        if editOrNot == false {
            self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "checkmark")
            editOrNot = true
            self.tableView.reloadData()
        } else {
            self.cancelAllToast()
            self.view.endEditing(true)
            if validateFields() {
                if currentUser.fName != settingsData["User[fName]"] as? String || currentUser.email != settingsData["User[email]"] as? String || currentUser.lang != settingsData["User[lang]"] as? String {
                    changeProfile(settingsChanges: settingsData) {
                        self.editOrNot = false
                        self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "edit")
                        self.tableView.reloadData()
                        self.showToastForSuccsesfulySaveSettings()
                        
                    }
                } else {
                    self.editOrNot = false
                    self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "edit")
                    self.tableView.reloadData()
                }
                
            }
        }
        closeKeyboard()
    }
    
    func changeProfile(settingsChanges:[String:Any] , succsesBlock : @escaping () -> Void) {
        SOIndicator.showInView(self.view)
        UserRequestSevice.sharedInstance.changeProfile(params: settingsChanges, imageData: nil, succsesBlock: { (succses) in
            Localize.setCurrentLanguage(self.setLanguage(languages: (self.languagesTextField?.text)!))
            SOIndicator.hide()
            succsesBlock()
        }) { (error) in
            SOIndicator.hide()
            if error as? String == Constant.kSINotInternetConectionError {
                self.showToastForNotInternetConnection()
            }
            if let errorData = error as? [String: Any] {
                SIErrorHelper().checkChangeProfileErrorBy(data: errorData, viewController: self)
            }
        }
    }
    
    func addItemsOnNavigation() {
        self.tabBarController?.title = "settings".localized()
        logOutBarItem = UIBarButtonItem.init(title: "logOut".localized(), style: UIBarButtonItemStyle.done, target: self, action: #selector(logOut))
        editBarItem = UIBarButtonItem.init(image:#imageLiteral(resourceName: "edit") , style: .done, target: self, action: #selector(self.edit))
        if isUserLogged {
            logOutBarItem.isEnabled = true
            editBarItem.isEnabled = true
        } else {
            editBarItem.isEnabled = false
            logOutBarItem.isEnabled = false
        }
        
        self.navigationItem.leftBarButtonItem = logOutBarItem
        self.navigationItem.rightBarButtonItem = editBarItem
    }
    
    //MARK: SettingsCellDelegate
    func onSelectLanguageCell() {
        let datePickerView = DatePickerView.init(dateMode: .data,
                                                 items: languages,
                                                 delegate: self,
                                                 dataSource: self)
        if let selectedLangIdx = languages.index(of: (languagesTextField?.text)!) {
            datePickerView.selectRow(selectedLangIdx, inComponent: 0, animated: false)
        }
        let height = datePickerView.pickerContainer.bounds.size.height
        changeTablePosition(height) {
            datePickerView.showInViewController(viewController: self)
        }
    }
    
    //MARK: DataPickerViewDataSource
    
    func willDismissDataPickerView() {
        let currentLang = Localize.currentLanguage()
        self.languagesTextField?.text = setLabelLanguage(languages: currentLang)
        closeKeyboard()
    }
    
    func didSelectRow(row: Int) {
        languagesTextField?.text = languages[row]
    }
    
    func willPresentDataPickerView(dataPicker: DatePickerView, selectedRow: Int) {
        self.view.endEditing(true)
    }
    
    func willDismissDataPickerViewWithDoneButton(selectedRow: Int) {
        
        if currentUser.isUserLogged == true && editOrNot == true {
            languagesTextField?.text = languages[selectedRow]
            
        } else {
            languagesTextField?.text = languages[selectedRow]
            Localize.setCurrentLanguage(setLanguage(languages: languages[selectedRow]))
            self.tableView.reloadData()
            closeKeyboard()
        }
        
    }
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let settingsCell = tableView.dequeueReusableCell(withIdentifier:
            "settingsCellID", for: indexPath) as? SettingsCell
        settingsCell?.settingsDelegate = self
        
        if editOrNot {
            settingsCell?.isUserInteractionEnabled = true
        } else {
            settingsCell?.isUserInteractionEnabled = false
        }
        
        settingsCell?.onClickTF = { (_ tfRect: CGRect) in
            //            let rect = self.view.convert(tfRect, to: self.view)
            //            settingsCell?.isUserInteractionEnabled = false
            //            self.selectedRect = rect
        }
        
        settingsCell?.onClickTFa = { (_ tap: UITapGestureRecognizer) in
            let location = tap.location(in: self.tableView)
            let selectedIndexPath = self.tableView.indexPathForRow(at: location)
            let selectedCell = self.tableView.cellForRow(at: selectedIndexPath!)  as? SettingsCell
            let rect = selectedCell?.editingTextField.frame
            self.selectedRect = selectedCell?.convert(rect!, to: self.view)
        }
        
        if settingsCell?.title.text == "language".localized() {
            languagesTextField = settingsCell?.editingTextField
        }
        
        settingsCell?.title.text = settingTitles[indexPath.row].localized()
        settingsCell?.setUserSettings(user: currentUser)
        settingsCell?.setKeyboardTypes(title: settingTitles[indexPath.row])
        if settingsCell?.title.text?.localized() == "language".localized() {
            if currentUser.isUserLogged == true && !editOrNot == true {
                settingsCell?.isUserInteractionEnabled = false
            } else {
                settingsCell?.isUserInteractionEnabled = true
            }
        }
        
        return settingsCell!
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.isIpad() {
            return 130
        } else {
            return 110
        }
    }
}
