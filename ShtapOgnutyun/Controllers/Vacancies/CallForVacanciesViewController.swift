//
//  CallForVacanciesViewController.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 5/21/18.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import UIKit

class CallForVacanciesViewController: BaseViewController {
    
    @IBOutlet weak var applyWorkLabel: SOLocalizedLabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "vacancies".localized()
        applyWorkLabel?.text = "apply_to_work".localized()
    }
}
