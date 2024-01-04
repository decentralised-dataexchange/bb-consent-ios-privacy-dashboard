//
//  BBConsentOrganisationViewController.swift
//  PrivacyDashboardiOS
//
//  Created by Mumthasir mohammed on 04/09/23.
//

import Foundation
import ExpandableLabel
import SafariServices

class BBConsentOrganisationViewController: BBConsentBaseViewController {
    @IBOutlet weak var orgTableView: UITableView!
    @IBOutlet weak var navTitleLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet var topConstraint : NSLayoutConstraint!
    @IBOutlet var topBarItemConstraint : NSLayoutConstraint!
    @IBOutlet weak var noDataAgreementsLbl: UILabel!
    
    var organisaionDeatils : OrganisationDetails?
    var records : DataAgreementRecords?
    var organization : Organization?
    var organisationId = ""
    var isNeedToRefresh = false
    var overViewCollpased = true
    let popover = BBConsentPopOver()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(BBConsentOrganisationViewController.consentValueModified),
                                       name: .consentChange,
                                       object: nil)
        setupUI()
        callOrganizationApi()
        callOrganisationDetailsApi()
    }
    
    func setupUI(){
        orgTableView.estimatedRowHeight = 52.0
        self.orgTableView.rowHeight = UITableView.automaticDimension
        orgTableView.tableFooterView = UIView()
        backBtn.layer.cornerRadius =  backBtn.frame.size.height/2
        moreBtn.layer.cornerRadius =  moreBtn.frame.size.height/2
        self.navigationController?.navigationBar.tintColor = .black
        noDataAgreementsLbl.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        if isNeedToRefresh == true{
            isNeedToRefresh = false
            callOrganisationDetailsApi()
        }
    }
    
    func callOrganizationApi(){
        self.addLoadingIndicator()
        let serviceManager = OrganisationWebServiceManager()
        serviceManager.managerDelegate = self
        serviceManager.getOrganization(orgId: self.organisationId)
    }
    
    
    func callOrganisationDetailsApi(){
        let serviceManager = OrganisationWebServiceManager()
        serviceManager.managerDelegate = self
        serviceManager.getOrganisationDetails(orgId: self.organisationId)
    }
    
    func getAllDataAgreementRecords() {
        let serviceManager = OrganisationWebServiceManager()
        serviceManager.managerDelegate = self
        serviceManager.getAllDataAgreementRecords(orgId: self.organisationId)
    }
    
    func requestForgetMe() {
        addLoadingIndicator()
        let serviceManager = OrganisationWebServiceManager()
        serviceManager.managerDelegate = self
        serviceManager.requestForgetMe(orgId: organisationId)
    }
    
    func requestDownloadData() {
        addLoadingIndicator()
        let serviceManager = OrganisationWebServiceManager()
        serviceManager.managerDelegate = self
        serviceManager.requestDownloadData(orgId: organisationId)
    }
    
    func getDownloadDataStatus() {
        addLoadingIndicator()
        let serviceManager = OrganisationWebServiceManager()
        serviceManager.managerDelegate = self
        serviceManager.getDownloadDataStatus(orgId: organisationId)
    }
    
    func getForgetMeStatus() {
        addLoadingIndicator()
        let serviceManager = OrganisationWebServiceManager()
        serviceManager.managerDelegate = self
        serviceManager.getForgetMeStatus(orgId: organisationId)
    }
    
    @IBAction func backButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func moreButtonClicked() {
        // Create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Create an action
        let firstAction: UIAlertAction = UIAlertAction(title: Constant.Strings.privacyPolicy.localized, style: .default) { action -> Void in
            
            if let privacyPolicy =  self.organization?.privacyPolicy {
                if self.verifyUrl(urlString: privacyPolicy) {
                    let webviewVC = self.storyboard?.instantiateViewController(withIdentifier: Constant.ViewControllerID.webViewVC) as! BBConsentWebViewViewController
                    webviewVC.urlString = privacyPolicy
                    self.navigationController?.pushViewController(webviewVC, animated: true)
                } else {
                    self.showWarningAlert(message: Constant.Alert.KPromptMsgNotConfigured)
                }
            }
        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: Constant.Strings.userRequests.localized, style: .default) { action -> Void in
            self.showRequestedStatus()
        }
        
        let thirdAction: UIAlertAction = UIAlertAction(title: Constant.Strings.consentHistory.localized, style: .default) { action -> Void in
            self.showConsentHistory()
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: Constant.Strings.cancel.localized, style: .cancel) { action -> Void in }
        
        // Add actions
        actionSheetController.addAction(firstAction)
        if BBConsentPrivacyDashboardiOS.shared.turnOnUserRequests {
            actionSheetController.addAction(secondAction)
        }
        actionSheetController.addAction(thirdAction)
        actionSheetController.addAction(cancelAction)
        
        // Present an actionSheet...
        // present(actionSheetController, animated: true, completion: nil)   // doesn't work for iPad
        actionSheetController.popoverPresentationController?.sourceView = moreBtn // works for both iPhone & iPad
        
        present(actionSheetController, animated: true) {
            debugPrint("#Option menu presented")
        }
    }
    
    @IBAction func allowAllButtonClicked() {
        self.addLoadingIndicator()
        let serviceManager = OrganisationWebServiceManager()
        serviceManager.managerDelegate = self
        serviceManager.allowAllConsentOfOrganisation(orgId: self.organisationId)
    }
    
    @objc func consentValueModified() {
        isNeedToRefresh = true
    }
    
    func showPopOver() {
        let popOverview = OrgPopOver.instanceFromNib(vc: self.classForCoder)
        let startPoint = CGPoint(x: self.view.frame.width - 30, y: 60)
        popOverview.privacyPolicyButton.addTarget(self, action: #selector(showPrivacyPolicy), for: .touchUpInside)
        popOverview.downloadDataButton.addTarget(self, action: #selector(tappedOnDownloadData), for: .touchUpInside)
        popOverview.forgetMeButton.addTarget(self, action: #selector(tappedOnForgetMeButton), for: .touchUpInside)
        popOverview.requestedStatus.addTarget(self, action: #selector(tappedOnRequestedStatusButton), for: .touchUpInside)
        popOverview.consentHistory.addTarget(self, action: #selector(tappedOnConsentHistoryButton), for: .touchUpInside)
        popover.show(popOverview, point: startPoint)
    }
    
    @objc func showPrivacyPolicy() {
        popover.dismiss()
        if let privacyPolicy = self.organisaionDeatils?.organization?.privacyPolicy {
            if self.verifyUrl(urlString: privacyPolicy) {
                let safariVC = SFSafariViewController(url: NSURL(string: privacyPolicy)! as URL)
                self.present(safariVC, animated: true, completion: nil)
                safariVC.delegate = self
            } else {
                self.showWarningAlert(message: Constant.Alert.KPromptMsgNotConfigured)
            }
        }
    }
    
    @objc func tappedOnRequestedStatusButton() {
        popover.dismiss()
        self.showRequestedStatus()
    }
    
    @objc func tappedOnConsentHistoryButton() {
        popover.dismiss()
        self.showConsentHistory()
    }
    
    @objc func tappedOnDownloadData() {
        popover.dismiss()
        self.getDownloadDataStatus()
    }
    
    @objc func tappedOnForgetMeButton() {
        popover.dismiss()
        self.getForgetMeStatus()
    }
    
    func showRequestedStatus() {
        let RequestStatusHistoryVC = Constant.getStoryboard(vc: self.classForCoder).instantiateViewController(withIdentifier: Constant.ViewControllerID.requestStatusHistoryVC) as! BBConsentRequestStatusViewController
        RequestStatusHistoryVC.orgId = organisationId
        navigationController?.pushViewController(RequestStatusHistoryVC, animated: true)
    }
    
    func showConsentHistory() {
        let ConsentHistoryVC = Constant.getStoryboard(vc: self.classForCoder).instantiateViewController(withIdentifier: Constant.ViewControllerID.consentHistoryVC) as! BBConsentHistoryViewController
        ConsentHistoryVC.orgId = organisationId
        navigationController?.pushViewController(ConsentHistoryVC, animated: true)
    }
    
    func verifyUrl(urlString: String?) -> Bool {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
}

extension BBConsentOrganisationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if organisaionDeatils?.purposeConsents != nil {
            if (organisaionDeatils?.purposeConsents?.count ?? 0) > 0 {
                return 3
            } else {
                return 1
            }
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return 1
        } else {
            if (organisaionDeatils?.purposeConsents?.count ?? 0) > 0 {
                return  organisaionDeatils?.purposeConsents?.count ?? 0
            }else{
                noDataAgreementsLbl.isHidden = false
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  indexPath.section == 0 {
            if indexPath.row == 0 {
                return 235
            } else {
                return UITableView.automaticDimension
            }
        } else if indexPath.section == 1 {
            return 62
        } else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  indexPath.section == 0 {
            if indexPath.row == 0 {
                let orgCell = tableView.dequeueReusableCell(withIdentifier:Constant.CustomTabelCell.KOrgDetailedImageCellID,for: indexPath) as! BBConsentDashboardHeaderCell
                orgCell.orgData = organization
                orgCell.showData()
                return orgCell
            } else {
                let orgOverViewCell = tableView.dequeueReusableCell(withIdentifier:Constant.CustomTabelCell.KOrgDetailedOverViewCellID,for: indexPath) as! BBConsentDashBoardOverviewCell
                //  orgOverViewCell.overViewLbl.text = organisaionDeatils?.organization?.descriptionField
                orgOverViewCell.overViewLbl.delegate = self
                orgOverViewCell.layoutIfNeeded()
                orgOverViewCell.overViewLbl.shouldCollapse = true
                orgOverViewCell.overViewTitleLbl?.text = "bb_consent_dashboard_overview".localized

                if overViewCollpased == true {
                    //  orgOverViewCell.overViewLbl.collapsed = overViewCollpased
                    //  orgOverViewCell.overViewLbl.numberOfLines = 3
                    orgOverViewCell.overViewLbl.collapsed = true
                    
                } else {
                    orgOverViewCell.overViewLbl.collapsed = false
                    //  orgOverViewCell.overViewLbl.numberOfLines = 0
                }
                orgOverViewCell.overViewLbl.textReplacementType = .word
                if organization?.descriptionField != nil {
                    let desc = organization?.descriptionField 
                    orgOverViewCell.overViewLbl.text = desc
                }
                return orgOverViewCell
            }
        } else if indexPath.section == 1 {
            let headerCell = tableView.dequeueReusableCell(withIdentifier:Constant.CustomTabelCell.KOrgDetailedConsentHeaderCellID,for: indexPath)
            return headerCell
        } else {
            let consentCell = tableView.dequeueReusableCell(withIdentifier:Constant.CustomTabelCell.purposeCell,for: indexPath) as! BBConsentDashboardUsagePurposeCell
            consentCell.tag = indexPath.row
            consentCell.consentInfo = organisaionDeatils?.purposeConsents?[indexPath.row]
            
            // Note: filtering dataAgreement from records to check 'optIn' value (both are getting from two api's)
            let dataAgreementIdsFromOrg = organisaionDeatils?.purposeConsents?.map({ $0.iD ?? ""})
            let record = records?.consentRecords?.filter({ $0.dataAgreementId == dataAgreementIdsFromOrg?[indexPath.row]})
            consentCell.swictOn = record?.count ?? 0 > 0 ?  record?[0].optIn ?? false : false
            
            var consentedCount = organisaionDeatils?.purposeConsents?[indexPath.row].dataAttributes?.count
            var totalCount = organisaionDeatils?.purposeConsents?[indexPath.row].dataAttributes?.count
        
            if record?.count ?? 0 > 0, record?[0].optIn  == false {
                consentedCount = 0
                totalCount = 0
            } else if record?.count == 0 || record?.count == nil {
                consentedCount = 0
                totalCount = 0
            }
            
            consentCell.consentedCount = consentedCount
            consentCell.totalCount = totalCount
            consentCell.delegate = self
            consentCell.showData()
            return consentCell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let consentVC = Constant.getStoryboard(vc: self.classForCoder).instantiateViewController(withIdentifier: Constant.ViewControllerID.consentListVC) as! BBConsentAttributesViewController
            consentVC.organisaionDeatils = self.organisaionDeatils
            consentVC.organization = self.organization
            consentVC.purposeInfo = organisaionDeatils?.purposeConsents?[indexPath.row]
           
            // Note: filtering dataAgreement from records to check 'optIn' value (both are getting from different api's)
            let dataAgreementIdsFromOrg = organisaionDeatils?.purposeConsents?.map({ $0.iD ?? ""})
            let record = records?.consentRecords?.filter({ $0.dataAgreementId == dataAgreementIdsFromOrg?[indexPath.row]})
            consentVC.consentVal = record?.count ?? 0 > 0 ? record?[0].optIn ?? false : false
            self.navigationController?.pushViewController(consentVC, animated: true)
        }
    }
}

extension BBConsentOrganisationViewController: WebServiceTaskManagerProtocol {
    
    func didFinishTask(from manager:AnyObject, response:(data:RestResponse?,error:String?)) {
        removeLoadingIndicator()
        
        if response.error != nil {
            if let serviceManager = manager as? OrganisationWebServiceManager {
                if serviceManager.serviceType == .OrgDetails {
                    
                }
            }
            showErrorAlert(message: (response.error)!)
            return
        }
        
        if let serviceManager = manager as? OrganisationWebServiceManager {
            if serviceManager.serviceType == .AllowAlConsent {
                getAllDataAgreementRecords()
            } else if serviceManager.serviceType == .UpdatePurpose {
                callOrganisationDetailsApi()
            } else if serviceManager.serviceType == .requestDownloadData {
                let downloadDataProgressVC = Constant.getStoryboard(vc: self.classForCoder).instantiateViewController(withIdentifier: Constant.ViewControllerID.downloadDataProgressVC) as! BBConsentDownloadDataProgressViewController
                downloadDataProgressVC.organisationId = organisationId
                downloadDataProgressVC.requestType = RequestType.DownloadData
                navigationController?.pushViewController(downloadDataProgressVC, animated: true)
            } else if serviceManager.serviceType == .requestForgetMe {
                let downloadDataProgressVC = Constant.getStoryboard(vc: self.classForCoder).instantiateViewController(withIdentifier: Constant.ViewControllerID.downloadDataProgressVC) as! BBConsentDownloadDataProgressViewController
                downloadDataProgressVC.organisationId = organisationId
                downloadDataProgressVC.requestType = RequestType.ForgetMe
                navigationController?.pushViewController(downloadDataProgressVC, animated: true)
            } else if serviceManager.serviceType == .getDownloadDataStatus {
                if let data = response.data?.responseModel as? RequestStatus {
                    if data.RequestOngoing ?? false {
                        let downloadDataProgressVC = Constant.getStoryboard(vc: self.classForCoder).instantiateViewController(withIdentifier: Constant.ViewControllerID.downloadDataProgressVC) as! BBConsentDownloadDataProgressViewController
                        downloadDataProgressVC.organisationId = organisationId
                        downloadDataProgressVC.requestType = RequestType.DownloadData
                        downloadDataProgressVC.requestStatus = data
                        navigationController?.pushViewController(downloadDataProgressVC, animated: true)
                    } else {
                        requestDownloadData()
                    }
                }
            } else if serviceManager.serviceType == .getForgetMeStatus {
                if let data = response.data?.responseModel as? RequestStatus {
                    if data.RequestOngoing ?? false {
                        let downloadDataProgressVC = Constant.getStoryboard(vc: self.classForCoder).instantiateViewController(withIdentifier: Constant.ViewControllerID.downloadDataProgressVC) as! BBConsentDownloadDataProgressViewController
                        downloadDataProgressVC.organisationId = organisationId
                        downloadDataProgressVC.requestType = RequestType.ForgetMe
                        downloadDataProgressVC.requestStatus = data
                        navigationController?.pushViewController(downloadDataProgressVC, animated: true)
                    } else {
                        requestForgetMe()
                    }
                }
            } else if serviceManager.serviceType == .Organization {
                if let data = response.data?.responseModel as? Organization {
                    organization = data
                    orgTableView.reloadData()
                }
            } else if serviceManager.serviceType == .OrgDetails {
                if let data = response.data?.responseModel as? OrganisationDetails {
                    organisaionDeatils = data
                    getAllDataAgreementRecords()
                    orgTableView.reloadData()
                }
            } else if serviceManager.serviceType == .GetDataAgreementRecords {
                if let data = response.data?.responseModel as? DataAgreementRecords {
                    records = data
                    let dataAgreementIDs = organisaionDeatils?.purposeConsents?.filter({ $0.lawfulUsage == false }).map({ $0.iD ?? "" }) ?? []
                    let idsWithAttributeRecords = records?.consentRecords?.map({ $0.dataAgreementId }) ?? []
                                        
                    for item in dataAgreementIDs {
                        // If item doesnt have record already
                        if !idsWithAttributeRecords.contains(item) {
                            // Create add record api call
                            let serviceManager = OrganisationWebServiceManager()
                            serviceManager.managerDelegate = self
                            serviceManager.createDataAgreementRecord(dataAgreementId: item)
                       }
                    }
                    orgTableView.reloadData()
                }
            } else if serviceManager.serviceType == .CreateDataAgreementRecord {
                getAllDataAgreementRecords()
            }
        }
        
        if let data = response.data?.responseModel as? OrganisationDetails {
            organisaionDeatils = data
            orgTableView.reloadData()
        }
    }
}

extension BBConsentOrganisationViewController: ExpandableLabelDelegate ,PurposeCellDelegate {
    
    func purposeSwitchValueChanged(status:Bool,purposeInfo:PurposeConsent?,cell:BBConsentDashboardUsagePurposeCell) {
        let serviceManager = OrganisationWebServiceManager()
        serviceManager.managerDelegate = self
        var alrtMsg = Constant.Alert.areYouSureYouWantToAllow
        var value = Constant.Alert.allow
        var titleStr = Constant.Alert.allow
       
        if status == false {
            alrtMsg = Constant.Alert.areYouSureYouWantToDisAllow
            value = Constant.Alert.disallow
            titleStr = Constant.Alert.disallow
        }
        
        let alerController = UIAlertController(title: Constant.AppSetupConstant.KAlertTitle, message:alrtMsg , preferredStyle: .alert)
        if status == false {
            alerController.addAction(UIAlertAction(title: titleStr, style: .destructive, handler: {(action:UIAlertAction) in
                let filteredRecord = self.records?.consentRecords?.map({ $0 }).filter({ $0.dataAgreementId ==  self.organisaionDeatils?.purposeConsents?[cell.tag].iD })
                if filteredRecord?.count ?? 0 > 0 {
                    serviceManager.updatePurpose(dataAgreementRecordId: filteredRecord?[0].id ?? "", dataAgreementId:  filteredRecord?[0].dataAgreementId ?? "", status: status)
                }
            }));
            alerController.addAction(UIAlertAction(title: Constant.Strings.cancel.localized, style: .cancel, handler: {(action:UIAlertAction) in
                cell.statusSwitch.isOn = !cell.statusSwitch.isOn
            }));
            
        } else {
            alerController.addAction(UIAlertAction(title: Constant.Strings.cancel.localized, style: .destructive, handler: {(action:UIAlertAction) in
                cell.statusSwitch.isOn = !cell.statusSwitch.isOn
            }));
            
            alerController.addAction(UIAlertAction(title: value, style: .default, handler: {(action:UIAlertAction) in
                let filteredRecord = self.records?.consentRecords?.map({ $0 }).filter({ $0.dataAgreementId ==  self.organisaionDeatils?.purposeConsents?[cell.tag].iD })
                if filteredRecord?.count ?? 0 > 0 {
                    serviceManager.updatePurpose(dataAgreementRecordId: filteredRecord?[0].id ?? "", dataAgreementId:  filteredRecord?[0].dataAgreementId ?? "", status: status)
                } else {
                    serviceManager.createDataAgreementRecord(dataAgreementId: self.organisaionDeatils?.purposeConsents?[cell.tag].iD ?? "")
                }
            }));
        }
        present(alerController, animated: true, completion: nil)
    }

    func willExpandLabel(_ label: ExpandableLabel) {
        overViewCollpased = false
        self.orgTableView.reloadData()
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {}
    
    func willCollapseLabel(_ label: ExpandableLabel) {}
    
    func didCollapseLabel(_ label: ExpandableLabel){
        overViewCollpased = true
        self.orgTableView.reloadData()
    }
}

extension BBConsentOrganisationViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

