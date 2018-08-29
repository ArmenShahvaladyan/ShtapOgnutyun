//
//  HistoryTableViewCell.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 5/8/18.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import UIKit

class HistoryTableViewCell: BaseTableViewCell {

    @IBOutlet weak var masterimageView: UIImageView?
    @IBOutlet weak var fullNameLabel: UILabel?
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var dateTitleLabel: UILabel!
    @IBOutlet weak var paidLabel: UILabel?
    @IBOutlet weak var paidTitleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel?
    @IBOutlet weak var rateView: FloatRatingView?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setMasterDetails(order: Order) {
        self.startLoading()
        let miliseconds = Int.milisecToString(miliseconds: order.endDate)
        self.dateLabel?.text = miliseconds
        
        self.masterimageView?.image = #imageLiteral(resourceName: "master_default")
        
        if let data = order.worker?.imageData {
            self.masterimageView?.image = UIImage(data: data)
            self.stopLoading()
        }
        
        self.fullNameLabel?.text = order.worker?.name?.value
        
        self.paidLabel?.text = String(order.price) + " ֏"
        self.rateLabel?.text = String(order.vote)
        self.rateView?.rating = order.vote != "" ? Float(order.vote)! : 0.0
        dateTitleLabel.text = "date".localized()
        paidTitleLabel.text = "paid".localized()
    }
}
