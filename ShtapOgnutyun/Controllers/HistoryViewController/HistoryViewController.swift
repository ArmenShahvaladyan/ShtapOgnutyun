//
//  HistoryViewController.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 5/8/18.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import UIKit
import Alamofire

class HistoryViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: IBOutlets

    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: Variables
    
    private var selectedIndexPath: IndexPath?
    private var contentViewController: ContentViewController?
    private var orders = [Order]()
    private var reachabilityManager = NetworkReachabilityManager()
    private var isUserLogged:Bool {
        return UserRequestSevice.sharedInstance.currentUser?.isUserLogged ?? false
    }
    
    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.contentInset = UIEdgeInsets.init(top: 30, left: 0, bottom: 30, right: 0)
        tableView?.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: Constant.historyCellID)
        tableView?.register(UINib(nibName: "BonusTableViewCell", bundle: nil), forCellReuseIdentifier: Constant.bonusCellID)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reachibilitymanager()
        self.title = "history".localized()
    }
    
    func reachibilitymanager() {
        reachabilityManager?.listener = { [weak self] status in
            let showHistory: (_ isEmpty: Bool) -> () = { [weak self] isEmpty in
                if self?.contentViewController != nil {
                    self?.contentViewController?.removeChildViewControllerFromParent()
                    self?.contentViewController = nil
                }
                self?.setDetegateForTable()
            }
            SOIndicator.showInView((self?.view)!)
            switch status {
            case .notReachable, .unknown:
                if (self?.isUserLogged)! {
                    self?.showOrdersFromDB(empty: { isEmpty in
                        showHistory(isEmpty)
                        SOIndicator.hide()
                    })
                } else {
                    SOIndicator.hide()
                    guard self?.contentViewController == nil else {
                        return
                    }
                    self?.showLoginVC()

                }
            case .reachable(.ethernetOrWiFi), .reachable(.wwan):
                if (self?.isUserLogged)! {
                    self?.getOrdersData(empty: { isEmpty in
                        showHistory(isEmpty)
                        SOIndicator.hide()
                    })
                } else {
                    SOIndicator.hide()
                    guard self?.contentViewController == nil else {
                        return
                    }
                    self?.showLoginVC()
                }
            }
        }
        
        reachabilityManager?.startListening()
    }
    
    private func setDetegateForTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    // MARK: Order
    func getOrdersData(empty: @escaping (Bool) -> Void) {
        UserRequestSevice.sharedInstance.getOrders(succsesBlock: { (orders) in
            self.showOrdersFromDB(empty: empty)
            SOIndicator.hide()
        }) { (error) in
            if error as? String == Constant.kSINotInternetConectionError {
                self.showToastForNotInternetConnection()
            }
            if let errorData = error as? [String: Any] {
                SIErrorHelper().checkGetOrdersWith(data:errorData , viewController: self)
            }
        }
    }
    
    func showOrdersFromDB(empty: @escaping (Bool) -> Void) {
        self.orders = RealmWrapper.sharedInstance.getAllObjectsOfModelFromRealmDB(Order.self) as! [Order]
        if self.orders.count == 0 {
            empty(true)
        } else {
            empty(false)
        }
    }
    
    func showLoginVC() {
        self.contentViewController = ContentViewController.init(login: true)
        self.addChildViewController(childVC: self.contentViewController!, toView: self.view, childFrame: self.view.bounds)
        self.contentViewController?.onLoginFromHistory = { [weak self] in
            self?.title = "history".localized()
            self?.contentViewController?.removeChildViewControllerFromParent()
            self?.contentViewController = nil
            SOIndicator.showInView((self?.view)!)
            self?.getOrdersData(empty: { isEmpty in
                self?.setDetegateForTable()
                SOIndicator.hide()
            })
        }
        self.contentViewController?.onRegisterFromHistory  = { [weak self] in
            self?.contentViewController?.removeChildViewControllerFromParent()
            self?.contentViewController = nil
            //self?.loading?.show()

            self?.getOrdersData(empty: { isEmpty in
                self?.setDetegateForTable()
                SOIndicator.hide()
            })
        }
    }
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let bonusCell = tableView.dequeueReusableCell(withIdentifier: Constant.bonusCellID, for: indexPath) as? BonusTableViewCell
            bonusCell?.clipsToBounds = true
            if let currentUser = UserRequestSevice.sharedInstance.currentUser {
                bonusCell?.bonusLabel.text = currentUser.bonus + " ֏"
            } else {
                bonusCell?.bonusLabel.text = "0 ֏"
            }
            bonusCell?.titleLabel.text = "bonus".localized()
            tableView.isScrollEnabled = orders.count != 0
            
            return bonusCell!
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.historyCellID, for: indexPath) as? HistoryTableViewCell
        cell?.clipsToBounds = true
        cell?.setMasterDetails(order: orders[indexPath.row - 1])

        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            let vc = RateMasterViewController.init(nibName: "RateMasterViewController", bundle: nil)
            vc.order = orders[indexPath.row - 1]
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            if UIDevice.isIpad() {
                return 100
            }
            return 80
        } else {
            if UIDevice.isIpad() {
                return 150
            }
            return 122
        }
    }

}
