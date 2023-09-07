//
//  ConsentListViewController.swift
//  iGrant
//
//  Created by Ajeesh T S on 29/06/18.
//  Copyright © 2018 iGrant.com. All rights reserved.
//

import UIKit
import ExpandableLabel

class ConsentListViewController: BBConsentBaseViewController {
    @IBOutlet weak var tableView: UITableView!
    // @IBOutlet weak var policyBtn: UIButton!
    @IBOutlet weak var disAllowAllBtn: UIButton!
    @IBOutlet  var disAllowAllBtnHeightCostrint: NSLayoutConstraint!
    var overViewCollpased = true
    // @IBOutlet weak var HeaderView: UIView!
    
    //  @IBOutlet weak var descriptionLabel: ExpandableLabel!
    var organisaionDeatils : OrganisationDetails?
    var purposeInfo : Purpose?
    var consentslist : [ConsentDetails]?
    var consentslistInfo : ConsentListingResponse?
    var isNeedToRefresh = false
    var isFromQR = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.title = purposeInfo?.name
        //  self.descriptionLabel.delegate = self
        //  self.descriptionLabel.text = //purposeInfo?.descriptionField
        tableView.tableFooterView = UIView()
        addRefershNotification()
        callConsentListApi()
        manageDisallowButton()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        managePolicyButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isNeedToRefresh == true{
            isNeedToRefresh = false
            callConsentListApi()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    func addRefershNotification(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(ConsentListViewController.consentValueModified),
                                       name: .consentChange,
                                       object: nil)
    }
    
    
    func managePolicyButton(){
        self.tableView.reloadData()
    }
    
    func manageDisallowButton() {
        
        if self.consentslistInfo?.consents.purpose.lawfulUsage == false{
            if consentslistInfo?.consents.count.consented != nil{
                if (consentslistInfo?.consents.count.consented )! < 1{
                    disAllowAllBtn.isHidden = true
                    disAllowAllBtnHeightCostrint.constant = 0
                }else{
                    disAllowAllBtn.isHidden = false
                    disAllowAllBtnHeightCostrint.constant = 45
                }
            }
        }else{
            disAllowAllBtn.isHidden = true
            disAllowAllBtnHeightCostrint.constant = 0
        }
    }
    
    @objc func consentValueModified(){
        isNeedToRefresh = true
    }
    
    @IBAction func policyBtnClicked(){
        if let url = self.consentslistInfo?.consents.purpose.policyURL{
            if url.isValidString{
                let webviewVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewViewController
                webviewVC.urlString = url
                self.navigationController?.pushViewController(webviewVC, animated: true)
            }else{
                self.showErrorAlert(message: "Invalid URL")
            }
        }
        
    }
    
    @IBAction func disallowallBtnClicked(){
        showConfirmationAlert()
    }
    
    func callConsentListApi(){
        // self.addLoadingIndicator()
        let serviceManager = OrganisationWebServiceManager()
        serviceManager.managerDelegate = self
        serviceManager.consentList(orgId: (self.organisaionDeatils?.organization.iD)!, purposeId: (self.purposeInfo?.iD)!, consentId: (self.organisaionDeatils?.consentID)!)
    }
    
    func showConfirmationAlert(){
        let alerController = UIAlertController(title: Constant.AppSetupConstant.KAppName, message: NSLocalizedString("Are you sure you want to disallow all ?", comment: ""), preferredStyle: .alert)
        alerController.addAction(UIAlertAction(title: NSLocalizedString("Disallow All", comment: ""), style: .destructive, handler: {(action:UIAlertAction) in
            self.calldisallowAllApi()
        }));
        alerController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: {(action:UIAlertAction) in
        }));
        present(alerController, animated: true, completion: nil)

    }
    
    func calldisallowAllApi(){
        // self.addLoadingIndicator()
        let serviceManager = OrganisationWebServiceManager()
        serviceManager.managerDelegate = self
        let value = "Disallow"
        NotificationCenter.default.post(name: .consentChange, object: nil)
        serviceManager.updatePurpose(orgId: (self.organisaionDeatils?.organization.iD)!, consentID:  (self.organisaionDeatils?.consentID)!, attributeId: "", purposeId: (purposeInfo?.iD)!, status: value)
    }
    
}

extension ConsentListViewController: WebServiceTaskManagerProtocol {
    
    func didFinishTask(from manager:AnyObject, response:(data:RestResponse?,error:String?)){
        // self.removeLoadingIndicator()
        
        if response.error != nil{
            self.showErrorAlert(message: (response.error)!)
            return
        }
        
        if let serviceManager = manager as? OrganisationWebServiceManager{
            if serviceManager.serviceType == .AllowAlConsent{
                //                self.callOrganisationDetailsApi()
            }
            else if serviceManager.serviceType == .UpdatePurpose{
                disAllowAllBtn.isHidden = true
                disAllowAllBtnHeightCostrint.constant = 0
                callConsentListApi()
            }
        }
        
        if let data = response.data?.responseModel as? ConsentListingResponse {
            self.consentslistInfo = data
            self.consentslist = data.consents.consentslist
            self.tableView.reloadData()
            manageDisallowButton()
            managePolicyButton()
        }
    }
    
}



extension  ConsentListViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if consentslist == nil{
            return 0
        }else{
            if section == 0 {
                return 2
            }
            return (consentslist?.count)!
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableViewAutomaticDimension
        }
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let orgOverViewCell = tableView.dequeueReusableCell(withIdentifier: Constant.CustomTabelCell.KOrgDetailedOverViewCellID, for: indexPath) as! BBConsentDashBoardOverviewCell
                //                orgOverViewCell.overViewLbl.text = organisaionDeatils?.organization?.descriptionField
                
                orgOverViewCell.overViewLbl.delegate = self
                orgOverViewCell.layoutIfNeeded()
                orgOverViewCell.overViewLbl.shouldCollapse = true
                
                if overViewCollpased == true {
                    //                    orgOverViewCell.overViewLbl.collapsed = overViewCollpased
                    //                    orgOverViewCell.overViewLbl.numberOfLines = 3
                    orgOverViewCell.overViewLbl.collapsed = true
                    
                } else {
                    orgOverViewCell.overViewLbl.collapsed = false
                    //                    orgOverViewCell.overViewLbl.numberOfLines = 0
                }
                orgOverViewCell.overViewLbl.textReplacementType = .word
                if self.consentslistInfo?.consents.purpose.descriptionField != nil {
                    let desc = (self.consentslistInfo?.consents.purpose.descriptionField)!
                    orgOverViewCell.overViewLbl.text = desc
                   //desc
                    //                    orgOverViewCell.overViewLbl.setHTMLFromString(text: "Aksjdh khaksjdh ksa dkhksadh  khadkjhsa kd kahsdkjashd kah dskh sakdh \n askdh kasd kadkhsakjdh ksajhd  kahsdkhsakjdhksa hdksha kdhaskj d \n \n akdhskjdhkasdh kasdhkjashdkjhsa dkashdkjsad ksahdkjashd ksa hdksa ksahdkjsahdkjsahdkjhsakjdhkasjhdkjsahd ksajhdksah dkhsakjdh ksajdksah dksadkhskajhd kjsahdkshakd h kashdk\n dashgdashgdgsadggasdgj")
                    //                    orgOverViewCell.overViewLbl.text = "Aksjdh khaksjdh ksa dkhksadh  khadkjhsa kd kahsdkjashd kah dskh sakdh \n askdh kasd kadkhsakjdh ksajhd  kahsdkhsakjdhksa hdksha kdhaskj d \n \n akdhskjdhkasdh kasdhkjashdkjhsa dkashdkjsad ksahdkjashd ksa hdksa ksahdkjsahdkjsahdkjhsakjdhkasjhdkjsahd ksajhdksah dkhsakjdh ksajdksah dksadkhskajhd kjsahdkshakd h kashdk\n dashgdashgdgsadggasdgj"
                    //                    cell.descriptionLbl.from(html: desc)
                }
                return orgOverViewCell
            default:
                let consentHeaderCell = tableView.dequeueReusableCell(withIdentifier:"ConsentHeaderTableViewCell",for: indexPath) as! ConsentHeaderTableViewCell
                
                if let url = self.consentslistInfo?.consents.purpose.policyURL{
                    if url.isValidString{
                        consentHeaderCell.policyButton.isHidden = false
                    }else{
                        consentHeaderCell.policyButton.isHidden = true
                    }
                }else{
                    consentHeaderCell.policyButton.isHidden = true
                }
                consentHeaderCell.policyButton.showRoundCorner(roundCorner: 3.0)
                consentHeaderCell.policyButton.layer.borderColor = UIColor(red:0.62, green:0.62, blue:0.62, alpha:1).cgColor
                consentHeaderCell.policyButton.layer.borderWidth = 0.5
                consentHeaderCell.policyButton.addTarget(self, action: #selector(policyBtnClicked), for: .touchUpInside)
                return consentHeaderCell
                
            }
        }
        
        
        let consentCell = tableView.dequeueReusableCell(withIdentifier:"ConsentCell",for: indexPath) as! ConsentTableViewCell
        consentCell.consentInfo = consentslist?[indexPath.row]
        consentCell.showData()
        if isFromQR {
            consentCell.consentTypeLbl.text =  NSLocalizedString("Allow", comment: "")
            //consentCell.rightArrow.isHidden = true
        }
        if self.consentslistInfo?.consents.purpose.lawfulUsage == false{
            
        }else {
            
        }
        return consentCell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section == 1 {
            if self.consentslistInfo?.consents.purpose.lawfulUsage == false && !isFromQR{
                let consentVC = self.storyboard?.instantiateViewController(withIdentifier: "ConsentVC") as! ConsentViewController
                consentVC.consent = consentslist?[indexPath.row]
                consentVC.orgID = self.consentslistInfo?.orgID
                consentVC.purposeDetails = self.consentslistInfo
                consentVC.purposeName = self.purposeInfo?.name ?? ""
                self.navigationController?.pushViewController(consentVC, animated: true)
            }
        }
    }
    
}

extension ConsentListViewController:ExpandableLabelDelegate{
    func willExpandLabel(_ label: ExpandableLabel) {
        //        label.collapsed = false
        overViewCollpased = false
        tableView.reloadData()
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        //        label.collapsed = true
        overViewCollpased = true
        tableView.reloadData()
    }
    
    
}
