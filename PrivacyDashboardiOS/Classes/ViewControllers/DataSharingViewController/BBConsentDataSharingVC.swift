//
//  BBConsentDataSharingVC.swift
//  AFDateHelper
//
//  Created by Mumthasir mohammed on 09/11/23.
//

import Foundation
import Kingfisher

class BBConsentDataSharingVC: BBConsentBaseViewController, WebServiceTaskManagerProtocol, UITextViewDelegate {
    // MARK: IBOutlets
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var ourLogoImageView: UIImageView!
    @IBOutlet weak var thierLogoImageView: UIImageView!
    @IBOutlet weak var betweenLogosImageView: UIImageView!
    @IBOutlet weak var textLabelOne: UILabel!
    @IBOutlet weak var textLabelTwo: UILabel!
    @IBOutlet weak var textLabelThree: UILabel!
    @IBOutlet weak var dataAgreementTextView: UITextView!
    
    // MARK: Variables
    var organizationData : Organization?
    var organizationDetailsData : OrganisationDetails?
    var dataAgreementId: String?
    var theirLogoImageUrl: String?
    var theirOrgName: String?
    var termsOfServiceText: String?
    var termsOFServiceUrl: String?
    var cancelButtonText: String?
    var sendDataBack : (([String: Any]) -> Void)?
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        readDataAgreementRecord { success, resultVal in
            if resultVal["errorCode"] as? Int == 500 {
                // If no record found for the data agreement ID
                // Show Datashare UI
                self.setUI()
                self.callOrganizationApi()
                self.callOrganisationDetailsApi()
            } else {
                // Return the records reponse
                self.sendDataBack?(resultVal)
            }
        }
    }
    
    func setUI() {
        cancelButton.backgroundColor = .clear
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.black.cgColor
        cancelButton.setTitle(cancelButtonText, for: .normal)
    }
    
    func setOrganisationInfo() {
        setLogoImageView()
        setDynamicTextInfos()
    }
    
    fileprivate func setLogoImageView() {
        // Our logo image
        let modifier = AnyModifier { request in
            var r = request
            r.setValue("Bearer \(UserInfo.currentUser()?.token ?? "")", forHTTPHeaderField: "Authorization")
            if let tokendata = BBConsentKeyChainUtils.load(key: "BBConsentApiKey") {
                let token = String(data: tokendata, encoding: .utf8) ?? ""
                r.setValue("ApiKey \(token)", forHTTPHeaderField: "Authorization")
                r.setValue(BBConsentPrivacyDashboardiOS.shared.userId ?? "", forHTTPHeaderField:  "X-ConsentBB-IndividualId")
            }
            return r
        }
        
        self.ourLogoImageView.image = UIImage(named: Constant.Images.defaultCoverImage)
        let logoImageUrl = URL(string: (organizationData?.logoImageURL ?? ""))
        let placeholder = UIImage(named: Constant.Images.defaultCoverImage, in: Constant.getResourcesBundle(vc: BBConsentBaseViewController().classForCoder), compatibleWith: nil)
        self.ourLogoImageView.kf.setImage(with: logoImageUrl, placeholder: placeholder, options: [.requestModifier(modifier)])
        
        if let url = theirLogoImageUrl {
            self.thierLogoImageView.isHidden = false
            self.betweenLogosImageView.isHidden = false
            let logoImageUrl = URL(string: (url))
            self.thierLogoImageView.kf.setImage(with: logoImageUrl)
        } else {
            self.thierLogoImageView.isHidden = true
            self.betweenLogosImageView.isHidden = true
        }
    }
    
    fileprivate func setDynamicTextInfos() {
        // First label
        let boldAttribute = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        let normalAttribute = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
        
        let partOne = NSMutableAttributedString(string: organizationData?.name ?? "", attributes: boldAttribute)
        let partTwo = NSMutableAttributedString(string: " wants to access the following data from ", attributes: normalAttribute)
        partOne.append(partTwo)
        
        var partThree = NSMutableAttributedString()
        var partFour = NSMutableAttributedString()
        if let name = theirOrgName {
            partThree = NSMutableAttributedString(string: name, attributes: boldAttribute)
            partFour = NSMutableAttributedString(string: " for user", attributes: normalAttribute)
        } else {
            partThree = NSMutableAttributedString(string: "the user", attributes: normalAttribute)
        }
      
        partThree.append(partFour)
        partOne.append(partThree)
        textLabelOne.attributedText = partOne
        // Second label
        textLabelTwo.text = "By clicking Authorise, \(organizationData?.name ?? "") App will be able to read the following data attributes:"
        // Third label
        textLabelThree.text = "Make sure that you trust \(organizationData?.name ?? "")"
        // Data agreement & Terms of service textview
        let normalAttributeTwo = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        let linkAttribute = [NSMutableAttributedString.Key.foregroundColor: UIColor.systemBlue, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        let dataAgreementTextOne = NSMutableAttributedString(string: "You may be sharing sensitive info with this site or app. See the ", attributes: normalAttributeTwo)
        let dataAgreementTextTwo = NSMutableAttributedString(string: "data agreement details ", attributes: linkAttribute)
        let dataAgreementTextThree = NSMutableAttributedString(string: "and ", attributes: normalAttributeTwo)
        let dataAgreementTextFour = NSMutableAttributedString(string: termsOfServiceText ?? "", attributes: linkAttribute)
        dataAgreementTextOne.append(dataAgreementTextTwo)
        dataAgreementTextOne.append(dataAgreementTextThree)
        dataAgreementTextOne.append(dataAgreementTextFour)
        
        _ = dataAgreementTextOne.setSubstringAsLink(substring: "data agreement details", linkURL: "dataAgreement://")
        _ = dataAgreementTextOne.setSubstringAsLink(substring: termsOfServiceText ?? "", linkURL: termsOFServiceUrl ?? "")
        dataAgreementTextView.delegate = self
        dataAgreementTextView.attributedText = dataAgreementTextOne
        dataAgreementTextView.isSelectable = true
        dataAgreementTextView.isEditable = false
        dataAgreementTextView.isUserInteractionEnabled = true
    }
    
    func createAttributesView() {
        let purpose = organizationDetailsData?.purposeConsents?.filter({ $0.iD == dataAgreementId })
        let dataAttributes = purpose?.map({ $0.dataAttributes })
        let someArray = dataAttributes?[0]?.map({ $0.name }) ?? []
        for nValue in someArray {
            let label = PaddingLabel()
            label.edgeInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            label.attributedText = NSAttributedString(string: nValue ?? "", attributes:
                                                        [.underlineStyle: NSUnderlineStyle.single.rawValue])
            label.textColor = .black
            labelStackView.addArrangedSubview(label)
        }
        labelStackView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        labelStackView.layer.cornerRadius = 10
        
    }
    
    // MARK: IBActions
    @IBAction func tapOnCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func tapOnAuthoriseButton(_ sender: Any) {
        // Create record Api call
        // Return the reponse
        
    }
    
    // MARK: API Calls
    func readDataAgreementRecord(completionBlock:@escaping (_ success: Bool, _ resultVal: [String: Any]) -> Void){
        BBConsentBaseWebService.shared.makeAPICall(urlString: Constant.URLStrings.fetchDataAgreement + (dataAgreementId ?? ""), parameters: [:], method: .get) { success, resultVal in
            if success {
                debugPrint(resultVal)
                completionBlock(true, resultVal)
            } else {
                debugPrint(resultVal)
                completionBlock(false, resultVal)
            }
        }
    }
    
    func callOrganizationApi(){
        self.addLoadingIndicator()
        let serviceManager = OrganisationWebServiceManager()
        serviceManager.managerDelegate = self
        serviceManager.getOrganization(orgId: "")
    }
    
    func callOrganisationDetailsApi(){
        let serviceManager = OrganisationWebServiceManager()
        serviceManager.managerDelegate = self
        serviceManager.getOrganisationDetails(orgId: BBConsentPrivacyDashboardiOS.shared.orgId ?? "")
    }
    
    // MARK: Delegate methods
    func didFinishTask(from manager: AnyObject, response: (data: RestResponse?, error: String?)) {
        if response.error != nil {
            if let serviceManager = manager as? OrganisationWebServiceManager {
                if serviceManager.serviceType == .Organization {
                    
                }
            }
            showErrorAlert(message: (response.error)!)
            return
        }
        
        if let serviceManager = manager as? OrganisationWebServiceManager {
            if serviceManager.serviceType == .Organization {
                if let data = response.data?.responseModel as? Organization {
                    organizationData = data
                    setOrganisationInfo()
                }
            } else if serviceManager.serviceType == .OrgDetails {
                if let data = response.data?.responseModel as? OrganisationDetails {
                    organizationDetailsData = data
                    createAttributesView()
                    self.removeLoadingIndicator()
                }
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if (URL.absoluteString == "dataAgreement://") {
            debugPrint("Navigate to data agreement detail screen!")
            let dataAgreementRecord = organizationDetailsData?.purposeConsents?.filter({ $0.iD == dataAgreementId })
            let dataAgreementVC = Constant.getStoryboard(vc: self.classForCoder).instantiateViewController(withIdentifier: "BBConsentDataAgreementVC") as! BBConsentDataAgreementVC
            dataAgreementVC.dataAgreementRecord = dataAgreementRecord
            self.navigationController?.pushViewController(dataAgreementVC, animated: true)
        } else if (URL.absoluteString == termsOFServiceUrl) {
            let url = Foundation.URL(string: termsOFServiceUrl ?? "")!
            UIApplication.shared.open(url)
        }
        return false
    }
}

// Padding Label
class PaddingLabel: UILabel {
    var edgeInset: UIEdgeInsets = .zero
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: edgeInset.top, left: edgeInset.left, bottom: edgeInset.bottom, right: edgeInset.right)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + edgeInset.left + edgeInset.right, height: size.height + edgeInset.top + edgeInset.bottom)
    }
}
