//
//  UnderlineTextField.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 5/2/18.
//  Copyright © 2018 My Mac. All rights reserved.
//

import UIKit

@IBDesignable

class UnderlineTextField : UITextField, UITextFieldDelegate {
    
    //MARK: class IBInspectable , IBOutLet properties
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var color: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var placeHolderColor: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var underLineColor: UIColor? = .purple
    
    private var border:CALayer?
    
    //MARK: class override methods
    
    override func awakeFromNib() {
        self.delegate = self
        self.commonInit()
    }
    
    private func commonInit() {
        
    }
    
    deinit {

    }
    
    override func draw(_ rect: CGRect) {
        createBottomBorder()
        setPlaceholderColor()
        tintColor = UIColor.blue
    }
    
    func setPlaceholderColor() {
        if placeholder != nil && placeholder != "" {
            self.attributedPlaceholder = NSAttributedString(string: placeholder!,attributes: [NSAttributedStringKey.foregroundColor: placeHolderColor])
        }
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0,
                      y: bounds.origin.y,
                      width: bounds.size.width,
                      height: bounds.size.height)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0,
                      y: bounds.origin.y,
                      width: bounds.size.width,
                      height: bounds.size.height)
    }
    
    //MARK: other methods
    
    func isEmptyField() -> Bool {
        if let text = self.text {
            return text.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty
        }
        return true
    }
    
    private func createBottomBorder() {
        borderStyle = UITextBorderStyle.none;
        
        border = CALayer()
        let b_width = CGFloat(1.0)
        border?.borderColor = underLineColor?.cgColor
        border?.frame = CGRect(x: 0, y: frame.size.height - b_width , width: frame.size.width, height: frame.size.height)
        border?.borderWidth = b_width
        self.layer.addSublayer(border!)
        self.layer.masksToBounds = true
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextFieldViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.image = image.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = color
            
            leftView = imageView
        } else {
            leftViewMode = UITextFieldViewMode.never
            leftView = nil
        }
        
    }
    
    func setWarningColor(_ warning:Bool) {
        let warningColor = warning ? UIColor.red : UIColor.gray
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!,
                                                        attributes: [NSAttributedStringKey.foregroundColor: warningColor])
        border?.borderColor = warningColor.cgColor
        textColor = warning ? UIColor.red : UIColor.black
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
}

