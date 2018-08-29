//
//  ServiceCollectionHeaderView.swift
//  ShtapOgnutyun
//
//  Created by Gohar on 03/05/2018.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import UIKit

class ServiceCollectionHeaderView: UICollectionReusableView {

    @IBOutlet weak var employerButton: SOLocalizedButton?
    @IBOutlet weak var consecteturButton: SOLocalizedButton?
    
    var clientOrVacancias: ((_ type: Bool)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        employerButton?.isSelected = true
        employerButton?.setTitle("client".localized(), for: .normal)
        consecteturButton?.setTitle("vacancies".localized(), for: .normal)
    }
    
    @IBAction func employerButtonClicked(_ sender: UIButton) {
        if clientOrVacancias != nil {
            clientOrVacancias!(true)
        }
       self.selectServiceToShow(select: true, selected: sender, deselected: consecteturButton!)
    }
    
    @IBAction func consecteturButtonClick(_ sender: UIButton) {
        if clientOrVacancias != nil {
            clientOrVacancias!(false)
        }
        self.selectServiceToShow(select: true, selected: sender, deselected: employerButton!)
    }
    
    func selectServiceToShow(select:Bool,selected: UIButton, deselected: UIButton) {
        selected.isSelected = select
        deselected.isSelected = !select
    }
}
