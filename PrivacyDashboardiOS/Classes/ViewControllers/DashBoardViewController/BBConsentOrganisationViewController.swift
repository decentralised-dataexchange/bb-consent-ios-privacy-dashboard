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
    
    var organisationId = ""
    var isNeedToRefresh = false
    var overViewCollpased = true
    let popover = BBConsentPopOver()
    
    let baseUrl = BBConsentPrivacyDashboardiOS.shared.baseUrl
    let api = OrganisationWebService()
    var dataAgreementsObj: DataAgreementsModel?
    var consentRecordsObj : RecordsModel?
    var organizationObj : OrganisationModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        callOrganisationApi()
        callRecordsApi()
        callDataAgreementsApi()
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
            callDataAgreementsApi()
        }
    }
    
    func callOrganisationApi() {
        let url =  baseUrl + "/service/organisation"
        self.api.makeAPICall(urlString: url, method:.get) { status, result in
            if status {
                let jsonDecoder = JSONDecoder()
                if let data = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) {
                    let model = try? jsonDecoder.decode(OrganisationModel.self, from: data)
                    debugPrint("### Organiosation:\(String(describing: model))")
                    self.organizationObj = model
                    self.orgTableView.reloadData()
                }
            }
        }
    }

    
    func callDataAgreementsApi() {
        let url = baseUrl + "/service/data-agreements?offset=0&limit=500"
        self.api.makeAPICall(urlString: url, method:.get) { status, result in
            if status {
                let jsonDecoder = JSONDecoder()
                if let data = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) {
                    let model = try? jsonDecoder.decode(DataAgreementsModel.self, from: data)
                    debugPrint("### DataAgreements:\(String(describing: model))")
                    self.dataAgreementsObj = model
                    self.orgTableView.reloadData()
                }
            }
        }
    }
    
    func callRecordsApi() {
        let url = baseUrl + "/service/individual/record/consent-record?offset=0&limit=500"
        self.api.makeAPICall(urlString: url, method:.get) { status, result in
            if status {
                let jsonDecoder = JSONDecoder()
                if let data = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) {
                    let model = try? jsonDecoder.decode(RecordsModel.self, from: data)
                    debugPrint("### Records:\(String(describing: model))")
                    self.consentRecordsObj = model
                    self.orgTableView.reloadData()
                    self.CheckAndCreateRecordForContractType()
                }
            }
        }
    }
    
    func callCreateDataAgreementApi(dataAgreementId: String) {
        let url = baseUrl + "/service/individual/record/data-agreement/" + dataAgreementId
        self.api.makeAPICall(urlString: url, method:.post) { status, result in
            debugPrint(status)
            self.orgTableView.reloadData()
        }
    }
    
    func callUpdatePurposeApi(dataAgreementRecordId: String, dataAgreementId: String, status: Bool, updateCompletion: @escaping (Bool) -> ()) {
        let url = baseUrl + "/service/individual/record/consent-record/" + dataAgreementRecordId + "?dataAgreementId=" + dataAgreementId
        let params  = ["optIn" : status]
        self.api.makeAPICall(urlString: url,parameters: params, method:.put) { status, result in
            if status {
                updateCompletion(true)
            }
        }
    }
    
    
    func CheckAndCreateRecordForContractType() {
        let dataAgreementIDs = dataAgreementsObj?.dataAgreements.filter({ $0.lawfulBasis != "consent" && $0.lawfulBasis != "legitimate_interest"  }).map({ $0.id }) ?? []
        let idsWithAttributeRecords = consentRecordsObj?.consentRecords.map({ $0.dataAgreementID }) ?? []
        for item in dataAgreementIDs {
            // If item doesnt have record already
            if !idsWithAttributeRecords.contains(item) {
                // Create add record api call
                callCreateDataAgreementApi(dataAgreementId: item)
            }
        }
    }
    
    @IBAction func backButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func moreButtonClicked() {
        // Create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Create an action
        let firstAction: UIAlertAction = UIAlertAction(title: Constant.Strings.privacyPolicy, style: .default) { action -> Void in
            
            if let privacyPolicy =  self.organizationObj?.organisation.policyURL {
                if self.verifyUrl(urlString: privacyPolicy) {
                    let webviewVC = self.storyboard?.instantiateViewController(withIdentifier: Constant.ViewControllerID.webViewVC) as! BBConsentWebViewViewController
                    webviewVC.urlString = privacyPolicy
                    self.navigationController?.pushViewController(webviewVC, animated: true)
                } else {
                    self.showWarningAlert(message: Constant.Alert.KPromptMsgNotConfigured)
                }
            }
        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: Constant.Strings.userRequests, style: .default) { action -> Void in
            self.showRequestedStatus()
        }
        
        let thirdAction: UIAlertAction = UIAlertAction(title: Constant.Strings.consentHistory, style: .default) { action -> Void in
            self.showConsentHistory()
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: Constant.Strings.cancel, style: .cancel) { action -> Void in }
        
        // Add actions
        actionSheetController.addAction(firstAction)
        if BBConsentPrivacyDashboardiOS.shared.turnOnUserRequests {
            actionSheetController.addAction(secondAction)
        }
        actionSheetController.addAction(thirdAction)
        actionSheetController.addAction(cancelAction)
        
        // Present an actionSheet...
        actionSheetController.popoverPresentationController?.sourceView = moreBtn // works for both iPhone & iPad
        
        present(actionSheetController, animated: true) {
            debugPrint("#Option menu presented")
        }
    }
    
    func showPopOver() {
        let popOverview = OrgPopOver.instanceFromNib(vc: self.classForCoder)
        let startPoint = CGPoint(x: self.view.frame.width - 30, y: 60)
        popOverview.privacyPolicyButton.addTarget(self, action: #selector(showPrivacyPolicy), for: .touchUpInside)
        popOverview.requestedStatus.addTarget(self, action: #selector(tappedOnRequestedStatusButton), for: .touchUpInside)
        popOverview.consentHistory.addTarget(self, action: #selector(tappedOnConsentHistoryButton), for: .touchUpInside)
        popover.show(popOverview, point: startPoint)
    }
    
    @objc func showPrivacyPolicy() {
        popover.dismiss()
        if let privacyPolicy = self.organizationObj?.organisation.policyURL{
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
        if dataAgreementsObj?.dataAgreements != nil {
            if (dataAgreementsObj?.dataAgreements.count ?? 0) > 0 {
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
            if (dataAgreementsObj?.dataAgreements.count ?? 0) > 0 {
                return  dataAgreementsObj?.dataAgreements.count ?? 0
            } else {
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
                orgCell.orgData = organizationObj
                orgCell.showData()
                return orgCell
            } else {
                let orgOverViewCell = tableView.dequeueReusableCell(withIdentifier:Constant.CustomTabelCell.KOrgDetailedOverViewCellID,for: indexPath) as! BBConsentDashBoardOverviewCell
                //  orgOverViewCell.overViewLbl.text = organisaionDeatils?.organization?.descriptionField
                orgOverViewCell.overViewLbl.delegate = self
                orgOverViewCell.layoutIfNeeded()
                orgOverViewCell.overViewLbl.shouldCollapse = true
                
                if overViewCollpased == true {
                    //  orgOverViewCell.overViewLbl.collapsed = overViewCollpased
                    //  orgOverViewCell.overViewLbl.numberOfLines = 3
                    orgOverViewCell.overViewLbl.collapsed = true
                    
                } else {
                    orgOverViewCell.overViewLbl.collapsed = false
                    //  orgOverViewCell.overViewLbl.numberOfLines = 0
                }
                orgOverViewCell.overViewLbl.textReplacementType = .word
                if organizationObj?.organisation.description != nil {
                    let desc = organizationObj?.organisation.description
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
            consentCell.consentInfo = dataAgreementsObj?.dataAgreements[indexPath.row]
            
            // Note: filtering dataAgreement from records to check 'optIn' value (both are getting from two api's)
            let dataAgreementIdsFromOrg =  dataAgreementsObj?.dataAgreements.map({ $0.id })
            let record = consentRecordsObj?.consentRecords.filter({ $0.dataAgreementID == dataAgreementIdsFromOrg?[indexPath.row]})
            consentCell.swictOn = record?.count ?? 0 > 0 ?  record?[0].optIn ?? false : false
            
            var consentedCount = dataAgreementsObj?.dataAgreements[indexPath.row].dataAttributes.count
            var totalCount = dataAgreementsObj?.dataAgreements[indexPath.row].dataAttributes.count
        
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
            consentVC.dataAgreementsModel = self.dataAgreementsObj
            consentVC.organization = self.organizationObj
            consentVC.purposeInfo = dataAgreementsObj?.dataAgreements[indexPath.row] 
           
            // Note: filtering dataAgreement from records to check 'optIn' value (both are getting from different api's)
            let dataAgreementIdsFromOrg = dataAgreementsObj?.dataAgreements.map({ $0.id }) 
            let record = consentRecordsObj?.consentRecords.filter({ $0.dataAgreementID == dataAgreementIdsFromOrg?[indexPath.row]})
            consentVC.consentVal = record?.count ?? 0 > 0 ? record?[0].optIn ?? false : false
            self.navigationController?.pushViewController(consentVC, animated: true)
        }
    }
}

extension BBConsentOrganisationViewController: ExpandableLabelDelegate ,PurposeCellDelegate {
    
    func purposeSwitchValueChanged(status:Bool,purposeInfo:PurposeConsent?,cell:BBConsentDashboardUsagePurposeCell) {
        let serviceManager = OrganisationWebServiceManager()
        // serviceManager.managerDelegate = self
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
                let filteredRecord = self.consentRecordsObj?.consentRecords.map({ $0 }).filter({ $0.dataAgreementID ==  self.dataAgreementsObj?.dataAgreements[cell.tag].id })
                if filteredRecord?.count ?? 0 > 0 {
                    self.callUpdatePurposeApi(dataAgreementRecordId: filteredRecord?[0].id ?? "", dataAgreementId:  filteredRecord?[0].dataAgreementID ?? "", status: status, updateCompletion: { success in
                        if success {
                            filteredRecord?[0].optIn = status
                            self.orgTableView.reloadData()
                        }
                    })
                }
            }));
            alerController.addAction(UIAlertAction(title: Constant.Strings.cancel, style: .cancel, handler: {(action:UIAlertAction) in
                cell.statusSwitch.isOn = !cell.statusSwitch.isOn
            }));
            
        } else {
            alerController.addAction(UIAlertAction(title: Constant.Strings.cancel, style: .destructive, handler: {(action:UIAlertAction) in
                cell.statusSwitch.isOn = !cell.statusSwitch.isOn
            }));
            
            alerController.addAction(UIAlertAction(title: value, style: .default, handler: {(action:UIAlertAction) in
                let filteredRecord = self.consentRecordsObj?.consentRecords.map({ $0 }).filter({ $0.dataAgreementID ==  self.dataAgreementsObj?.dataAgreements[cell.tag].id })
                if filteredRecord?.count ?? 0 > 0 {
                    self.callUpdatePurposeApi(dataAgreementRecordId: filteredRecord?[0].id ?? "", dataAgreementId:  filteredRecord?[0].dataAgreementID ?? "", status: status, updateCompletion: { success in
                        if success {
                            filteredRecord?[0].optIn = status
                            self.orgTableView.reloadData()
                        }
                    })
                } else {
                    serviceManager.createDataAgreementRecord(dataAgreementId: self.dataAgreementsObj?.dataAgreements[cell.tag].id ?? "")
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

