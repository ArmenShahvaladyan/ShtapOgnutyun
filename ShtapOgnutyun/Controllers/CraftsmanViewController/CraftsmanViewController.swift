//
//  CraftsmanViewController.swift
//  ShtapOgnutyun
//
//  Created by Gohar on 08/05/2018.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import UIKit

class CraftsmanViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var craftmanTableView: UITableView?
    @IBOutlet weak var emptyCrafstManLabel: UILabel!
    
    // MARK: Variables
    private var selectedIndexPath: IndexPath?
    var masters = [Master]()
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if masters.count > 0 {
            craftmanTableView?.delegate = self
            craftmanTableView?.dataSource = self
            craftmanTableView?.register(UINib(nibName: "CraftsmanTableViewCell", bundle: nil), forCellReuseIdentifier: Constant.craftsmanCellID)
            craftmanTableView?.estimatedRowHeight = 180
            craftmanTableView?.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
            emptyCrafstManLabel.isHidden = true
            craftmanTableView?.isHidden = false
        } else {
            if !AlamofireWrapper.isConnectedToInternet() {
                emptyCrafstManLabel.isHidden = true
                DispatchQueue.main.async {
                    self.showToastForNotInternetConnection()
                }
            } else {
                emptyCrafstManLabel.isHidden = false
            }
            craftmanTableView?.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "craftsman".localized()
    }
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return masters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.craftsmanCellID, for: indexPath) as? CraftsmanTableViewCell
        cell?.master = masters[indexPath.row]
        cell?.fillWith(master: masters[indexPath.row])
        cell?.onOpenCell = { (button: UIButton) -> Void in
            cell?.cellSelected = true
            if self.selectedIndexPath == indexPath {
                let previewCell = tableView.cellForRow(at: self.selectedIndexPath!) as? CraftsmanTableViewCell
                previewCell?.cellSelected = false
                self.selectedIndexPath = nil
            } else {
                if self.selectedIndexPath != nil  {
                    let previewCell = tableView.cellForRow(at: self.selectedIndexPath!) as? CraftsmanTableViewCell
                    previewCell?.cellSelected = false
                }
                self.selectedIndexPath = indexPath
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        
        if selectedIndexPath != indexPath {
            cell?.disappearView(animated: false)
        } else {
            cell?.appearView(animated: false)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ContactUsViewController(nibName: "ContactUsViewController", bundle: nil)
        vc.workerId = masters[indexPath.row].id
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.isIpad() {
            return selectedIndexPath == indexPath ? 280 : 170
        } else {
            return selectedIndexPath == indexPath ? 250 : 120
        }
    }
}

