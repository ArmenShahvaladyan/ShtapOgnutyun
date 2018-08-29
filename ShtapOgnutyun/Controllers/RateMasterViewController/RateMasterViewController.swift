//
//  RateMasterViewController.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 5/7/18.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import UIKit

class RateMasterViewController: BaseViewController, UITextViewDelegate, FloatRatingViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var onlineOrderButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var fullNamelabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var commentTextView: SOTextView!
    @IBOutlet weak var textViewheightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainViewHeightConstraint: NSLayoutConstraint!//0.6
    @IBOutlet weak var commentButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var masterAvatar: UIImageView? {
        didSet {
            self.masterAvatar?.image = #imageLiteral(resourceName: "master_default")
            
            if let data = order?.worker?.imageData {
                self.masterAvatar?.image = UIImage(data: data)
            }
        }
    }
    
    @IBOutlet weak var commentButton: BorderedButton? {
        didSet {
            if order?.isVoted == true {
                rateView?.editable = false
                if order?.isCommented == true {
                    commentButton?.backgroundColor = UIColor.gray
                    commentButton?.isEnabled = false
                } else {
                    commentButton?.backgroundColor = UIColor.soBarColor_1
                }
            } else {
                commentButton?.backgroundColor = UIColor.gray
                commentButton?.isEnabled = false
            }
        }
    }
    
    @IBOutlet weak var rateView: FloatRatingView? {
        didSet {
            if order?.vote != ""  {
                rateView?.rating = Float((order?.vote)!)!
                rateView?.editable = false
            } else {
                rateView?.rating = 0.0
            }
            
        }
    }
    
    // MARK: Variables
    private var mainViewMainConstraint: NSLayoutConstraint?
    private var isChangedCenter: Bool = false
    var order: Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rateView?.delegate = self
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTexts()
    }
    // MARK: UITextViewDelegate

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var txt = textView.text
        if range.length == 1 {
            txt?.removeLast()
        } else {
            txt = txt! + text
        }
        if txt?.count == 0 {
            commentTextView.placeHolder = "please_enter_your_comment".localized()
        } else {
            commentTextView.placeHolder = ""
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 200
    }
    
    
    // MARK: Private Api
    
    private func setTexts() {
        title = "rate_master".localized()
        onlineOrderButton.setTitle("online".localized(), for: .normal)
        commentButton?.setTitle("comment".localized(), for: .normal)
        fullNamelabel.text = order?.worker?.name?.value
        commentTextView.placeHolder = "please_enter_your_comment".localized()
    }
    
    private func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden), name: .UIKeyboardWillHide, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tapGesture)
        callButton.layer.cornerRadius = callButton.bounds.height / 2
        commentTextView.delegate = self
        commentTextView.layer.cornerRadius = 5
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            var aRect = self.view.frame
            aRect.size.height -= height;
            
            if commentTextView != nil {
                var selectedRect = mainView.convert((commentTextView?.frame)!, to: self.view)
                selectedRect.origin.y += commentTextView.bounds.height
                if !(aRect.contains(selectedRect.origin)) {
                    var h = height - (self.view.bounds.size.height - selectedRect.origin.y)
                    h -= 20
                    var center = self.view.center
                    center.y -= h
                    isChangedCenter = true
                    UIView.animate(withDuration: 0.3) {
                        self.mainView.center = center
                    }
                }
            } else {
                isChangedCenter = false
            }
        }
    }
    
    @objc private func keyboardWillHidden(notification: NSNotification) {
        if isChangedCenter {
            isChangedCenter = false
            var center = mainView.center
            var h = self.view.bounds.height / 2
            h += ((self.navigationController?.navigationBar.bounds.height)! + UIApplication.shared.statusBarFrame.size.height) / 2
            center.y = h
            UIView.animate(withDuration: 0.3) {
                self.mainView.center = center
            }
        }
    }
    
    @objc private func handleTap() {
        self.view.endEditing(true)
    }
    

    private func showAlertForCantOpenURL() {
        let ac = UIAlertController(title: "warning".localized(), message: "this_app_is_not_allowed_to_query_for_scheme_tel".localized(), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok".localized(), style: .default) { (sender) in
            ac.dismiss(animated: true, completion: nil)
        }
        ac.addAction(okAction)
        self.present(ac, animated: true, completion: nil)
    }
    
    // MARK: Actions
    
    @IBAction func comment(_ sender: BorderedButton) {
        var multiplier = mainViewHeightConstraint.multiplier
        multiplier = round(100 * multiplier) / 100
        if multiplier == 0.6 {
            sender.setTitle("send".localized(), for: .normal)
            textViewheightConstraint.constant = 100
            commentButtonTopConstraint.constant = 20
            mainViewHeightConstraint = mainViewHeightConstraint.changeMultiplier(multiplier: 0.9)
        } else {
            sender.setTitle("comment".localized(), for: .normal)
            textViewheightConstraint.constant = 0
            commentButtonTopConstraint.constant = 0
            mainViewHeightConstraint = mainViewHeightConstraint.changeMultiplier(multiplier: 0.6)
            sendComment()
        }
        
        UIView.animate(withDuration: 0.3) {
            self.rateView?.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }

    
    func sendRate() {
        if !(order?.isVoted)! {
            showAlertForConfirmRate()
        }
    }
    
    func rateMaster() {
        UserRequestSevice.sharedInstance.rateOrder(orderID: (order?.id)!, vote: Int((rateView?.rating)!), succsesBlock: {
            self.showRateSucceed()
            self.commentButton?.backgroundColor = UIColor.soBarColor_1
            self.commentButton?.isEnabled = true
            self.rateView?.editable = false
            self.rateView?.isUserInteractionEnabled = false
        }) { (error) in
            if error as? String == Constant.kSINotInternetConectionError {
                self.showToastForNotInternetConnection()
            }
            if let errorData = error as? [String : Any] {
                SIErrorHelper().checkRateOrderWith(data: errorData, viewController: self)
            }
        }
    }
    
    func showAlertForConfirmRate() {
        let rateAlert = UIAlertController(title: "rate_order".localized(), message: "your_rate_for_order_is".localized() + " " + "\(Int((self.rateView?.rating)!))" as String, preferredStyle: UIAlertControllerStyle.alert)
        rateAlert.addAction(UIAlertAction(title: "Ok".localized(), style: .default, handler: { (action: UIAlertAction!) in
           
            self.rateMaster()
        }))
        rateAlert.addAction(UIAlertAction(title: "cancel".localized(), style: .cancel, handler: { (action: UIAlertAction!) in
        
        }))
        self.present(rateAlert, animated: true, completion: nil)
    }
    
    func sendComment() {
        if self.commentTextView.text.count > 1 && self.commentTextView.text.count < 200 {
            SOIndicator.showInView(self.view)
            UserRequestSevice.sharedInstance.commentOrder(orderID: (order?.id)!, comment: commentTextView.text, succsesBlock: {
                SOIndicator.hide()
                self.view.endEditing(true)
                self.commentButton?.backgroundColor = .gray
                self.commentButton?.isEnabled = false
                self.rateView?.editable = false
            }) { (error) in
                SOIndicator.hide()
                self.view.endEditing(true)
                if error as? String == Constant.kSINotInternetConectionError {
                    self.showToastForNotInternetConnection()
                }
                if let errorData = error as? [String: Any] {
                    SIErrorHelper().checkCommentOrderWith(data: errorData, viewController: self)
                }
            }
        }
    }
    
    
    @IBAction func call(_ sender: Any) {
        let officePhoneNumber = UserDefaults.standard.value(forKey: "officePhoneNumber") as? String
        guard let numberUrl = URL(string: "tel://" + officePhoneNumber!) else { return }
        
        if UIApplication.shared.canOpenURL(numberUrl) {
            UIApplication.shared.open(numberUrl)
        } else {
            showAlertForCantOpenURL()
        }
    }

    @IBAction func onlineOrder() {
        self.cancelAllToast()
        if UserRequestSevice.sharedInstance.currentUser != nil {
                UserRequestSevice.sharedInstance.createOrderWith(workerid: (order?.worker?.id)!, succsesBlock: {
                    self.showErrorOrderSuccsefullyCreated()
                }) { error in
                    if error as? String == Constant.kSINotInternetConectionError {
                        self.showToastForNotInternetConnection()
                    }
                    if let errorData = error as? [String: Any] {
                        SIErrorHelper().checkCreateOrderWith(data: errorData, viewController: self)
                    }
                }
            } else {
                self.showToastForLogin()
            }
    }
}
