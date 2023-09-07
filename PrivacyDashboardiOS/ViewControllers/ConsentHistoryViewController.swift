
//
//  ConsentHistoryViewController.swift
//  iGrant
//
//  Created by Ajeesh T S on 21/10/18.
//  Copyright © 2018 iGrant.com. All rights reserved.
//

import UIKit
import SDStateTableView
import SwiftEntryKit

enum ConsentHistoryFilterMode {
    case ViewAll
    case ByOrg
    case SortByDate
}

class ConsentHistoryViewController: BBConsentBaseViewController {
    @IBOutlet weak var historyListTable: SDStateTableView!
    var consentHistoryDetails: ConsentHistoryData?
    var histories: [ConsentHistory]?
    var orgId: String?
    var orgList:[Organization] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyListTable.dataSource = self
        historyListTable.delegate = self
        navigationController?.navigationBar.isHidden = false
        callHistoryListApi(orgID: self.orgId ?? "")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = NSLocalizedString("Consent History", comment: "")
    }
    

    func callHistoryListApi(orgID: String) {
        // self.addLoadingIndicator()
        let serviceManager = NotificationServiceManager()
        serviceManager.managerDelegate = self
        serviceManager.getConsentHistoryListWith(OrgID: orgID)
    }
}

extension ConsentHistoryViewController:WebServiceTaskManagerProtocol{
    
    func didFinishTask(from manager:AnyObject, response:(data:RestResponse?,error:String?)){
        // self.removeLoadingIndicator()
        
        if response.error != nil{
            self.showErrorAlert(message: (response.error)!)
            return
        }
        
        if let serviceManager = manager as? NotificationServiceManager{
            if serviceManager.serviceType == .ConsentHistoryList{
                if let data = response.data?.responseModel as? ConsentHistoryData {
                    self.consentHistoryDetails = data
                    if self.histories == nil {
                        self.histories = [ConsentHistory]()
                    }
                    if serviceManager.isLoadMore {
                        self.histories?.append(contentsOf: data.consentHistory)
                        
                    }else {
                        self.histories = data.consentHistory
                        if (self.histories?.count ?? 0) < 1 {
                            self.historyListTable.setState(.withImage(image: nil, title: "", message: NSLocalizedString("No history available", comment: "")))
                        }
                    }
                    self.historyListTable.reloadData()
                }
            }
        }
    }
}


extension  ConsentHistoryViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return histories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:Constant.CustomTabelCell.KEventCellID,for: indexPath) as! HistoryListTableViewCell
        cell.timeLbl.text = self.histories?[indexPath.row].timeStamp
        cell.history = self.histories?[indexPath.row]
        cell.showData()
       
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = .white
        } else {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //        self.showDetailedView(indexPath: indexPath)
        
//
//        let detailedVC = self.storyboard?.instantiateViewController(withIdentifier: "OrgNotificationDetailedVC") as! NotificationDetailsViewController
//        detailedVC.hidesBottomBarWhenPushed = true
//        detailedVC.notification = self.notificaions?[indexPath.row]
//        if let notId = self.notificaions?[indexPath.row].iD{
//            detailedVC.notificationId = notId
//        }
//        self.navigationController?.pushViewController(detailedVC, animated: true)
    }
    
    
}
