//
//  ServicesCollectionViewCell.swift
//  ShtapOgnutyun
//
//  Created by Gohar on 19/04/2018.
//  Copyright © 2018 Gohar. All rights reserved.
//

import UIKit
import AlamofireImage

class ServicesCollectionViewCell: UICollectionViewCell {
    
    // MARK: Variables
    
    // MARK: IBOutlets
    @IBOutlet private weak var icon: UIImageView?
    @IBOutlet private weak var name: UILabel?
    @IBOutlet private weak var containerView: UIView?
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    //MARK: Lifecycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView?.layer.cornerRadius = 10
        self.dropShadow()
    }
    
    func fillWith(category c: Category) {
        self.startLoading()
        self.name?.text = c.name?.value
        self.icon?.image = #imageLiteral(resourceName: "category_default")
        if let data = c.imageData {
            self.icon?.image = UIImage(data: data)
            self.stopLoading()
        }
    }
    
    private func startLoading() {
        self.loadingIndicator.isHidden = false
        self.loadingIndicator.startAnimating()
    }
    
    private func stopLoading() {
        self.loadingIndicator.stopAnimating()
    }
}
