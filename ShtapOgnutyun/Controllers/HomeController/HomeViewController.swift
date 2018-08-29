//
//  HomeViewController.swift
//  ShtapOgnutyun
//
//  Created by Gohar on 17/04/2018.
//  Copyright © 2018 Gohar. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    @IBOutlet private weak var collectionView: UICollectionView?
    @IBOutlet private weak var notFoundLabel: UILabel!
    
    // MARK: Variables
    var isClient = true
    var headerView: ServiceCollectionHeaderView?
    
    private var categoriesOfClient = [Category]() {
        willSet {
            self.categories = newValue
        }
    }
    private var categoriesOfVacancies = [Category]()
    private var reachabilityManager = NetworkReachabilityManager()
    private var categories = [Category]()
    
    //MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "home".localized()
        setCollection()
        SOIndicator.showInView(self.view)
        reachabilityManager?.listener = {[weak self] status in
            switch status {
            case .notReachable, .unknown:
                self?.showCategories()
            //SOIndicator.hide()
            case .reachable(.ethernetOrWiFi), .reachable(.wwan):
                self?.getCategories()
            }
        }
        
        if !AlamofireWrapper.isConnectedToInternet() {
            showCategories()
        }
        reachabilityManager?.startListening()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCategories()
        headerView?.employerButton?.isSelected = true
        headerView?.consecteturButton?.isSelected = false
        isClient = true
        self.navigationItem.title = "home".localized()
        self.collectionView?.reloadData()
        
    }
    
    //MARK: Functions
    
    func showCategories() {
        let newCategories = RealmWrapper.sharedInstance.getAllObjectsOfModelFromRealmDB(Category.self) as! [Category]
        self.notFoundLabel.isHidden = newCategories.count > 0
        self.filterCategories(categories: newCategories)
        self.collectionView?.reloadData()
    }
    
    func getCategories() {
        SOIndicator.showInView(self.view)
        UserRequestSevice.sharedInstance.getCategories(succsesBlock: {
            self.showCategories()
            SOIndicator.hide()
        }) { (error) in
            if error as? String == Constant.kSINotInternetConectionError {
                self.showToastForNotInternetConnection()
            }
            if let errorData = error as? [String: Any] {
                SIErrorHelper().checkGetCatergorysErrorWith(data:errorData, viewController:self)
            }
            SOIndicator.hide()
        }
    }
    
    func setCollection() {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = 20
        var itemWidth = self.view.bounds.size.width / 2 - 50
        if UIDevice.isIpad() {
            itemWidth -= 7
            flowLayout.minimumLineSpacing = 30
        }
        flowLayout.itemSize = CGSize.init(width: itemWidth, height: itemWidth)
        flowLayout.minimumInteritemSpacing = 10
        collectionView?.contentInset = UIEdgeInsetsMake(5, 5, 30, 5)
        //UIEdgeInsetsMake(5, 10, 30, 10)
        //UIEdgeInsetsMake(5, 0, 30, 0)
        collectionView?.collectionViewLayout = flowLayout
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        collectionView?.register(UINib.init(nibName: "ServicesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constant.servicesCellID)
        
        let headerNib = UINib(nibName: "ServiceCollectionHeaderView", bundle: nil)
        self.collectionView?.register(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ServiceCollectionHeaderView")
    }
    
    func filterCategories(categories:[Category]) {
        categoriesOfClient = categories.filter { (category) -> Bool in
            return category.typeId == 1
        }
        categoriesOfVacancies = categories.filter { (category) -> Bool in
            return category.typeId == 2
        }
    }
    
    // MARK: UICollectionViewDelegate , UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.servicesCellID, for: indexPath) as? ServicesCollectionViewCell
        
        cell?.fillWith(category: categories[indexPath.row])
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isClient {
            SOIndicator.showInView(self.view!)
            if AlamofireWrapper.isConnectedToInternet() {
                UserRequestSevice.sharedInstance.getWorkersByCategories(catId: categoriesOfClient[indexPath.row].id, succsesBlock: { (masters) in
                    RealmWrapper.sharedInstance.updateObjectsWithPrinaryKey {
                        for master in masters {
                            self.categoriesOfClient[indexPath.row].masters.append(master)
                        }
                        let craftsVC = CraftsmanViewController(nibName: "CraftsmanViewController", bundle: nil)
                        craftsVC.masters = masters
                        SOIndicator.hide()
                        self.navigationController?.pushViewController(craftsVC, animated: true)
                    }
                }) { (error) in
                    if error as? String == Constant.kSINotInternetConectionError {
                        self.showToastForNotInternetConnection()
                    }
                    if let errorData = error as? [String : Any] {
                        SIErrorHelper().checkGetWorkersByCategoriesErrorWith(data:errorData, viewController:self)
                    }
                }
            } else {
                let masters = self.categoriesOfClient[indexPath.row].masters
                SOIndicator.hide()
                if masters.count > 0 {
                    let craftsVC = CraftsmanViewController(nibName: "CraftsmanViewController", bundle: nil)
                    for master in masters {
                        craftsVC.masters.append(master)
                    }
                    self.navigationController?.pushViewController(craftsVC, animated: true)
                } else {
                    let craftsVC = CraftsmanViewController(nibName: "CraftsmanViewController", bundle: nil)
                    craftsVC.masters = [Master]()
                    self.navigationController?.pushViewController(craftsVC, animated: true)
                }
            }
        } else {
            let viewForVacancies = CallForVacanciesViewController(nibName: "CallForVacanciesViewController", bundle: nil)
            self.navigationController?.pushViewController(viewForVacancies, animated: true)
        }
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout  collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var size:CGSize?
        if UIDevice.isIpad() {
            size = CGSize(width: self.view.frame.width, height: 130)
        } else {
            size = CGSize(width: self.view.frame.width, height: 80)
        }
        return size!
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            self.headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ServiceCollectionHeaderView", for: indexPath) as? ServiceCollectionHeaderView
            headerView?.clientOrVacancias = {[weak self] type in
                self?.isClient = type
                self?.categories = (type ? self?.categoriesOfClient : self?.categoriesOfVacancies)!
                if type == true && (self?.categories.count)! == 0 {
                    self?.notFoundLabel.isHidden = false
                    self?.notFoundLabel.text = "not_found_categories".localized()
                    return
                } else {
                    self?.notFoundLabel.isHidden = true
                }
                
                if type == false && (self?.categories.count)! == 0 {
                    self?.notFoundLabel.isHidden = false
                    self?.notFoundLabel.text = "no_vacancies_found".localized()
                } else {
                    self?.notFoundLabel.isHidden = true
                }
            
                self?.collectionView?.reloadData()
            }
            headerView?.employerButton?.setTitle("client".localized(), for: .normal)
            headerView?.consecteturButton?.setTitle("vacancies".localized(), for: .normal)
            
            return self.headerView!
        default:
            assert(false, "Unexpected element kind")
        }
    }
}

