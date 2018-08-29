//
//  BaseTableViewCell.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 6/11/18.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func startLoading() {
        self.loadingIndicator.isHidden = false
        self.loadingIndicator.startAnimating()
    }
    
    func stopLoading() {
        self.loadingIndicator.stopAnimating()
    }
}
