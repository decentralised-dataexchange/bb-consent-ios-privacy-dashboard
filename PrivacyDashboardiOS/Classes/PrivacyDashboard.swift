//
//  PrivacyDashboard.swift
//  PrivacyDashboardiOS
//
//  Created by Mumthasir mohammed on 06/11/23.
//

import Foundation

public class PrivacyDashboard {
    public static var receiveDataBackFromPrivacyDashboard : (([String: Any]) -> Void)?
    
    // MARK: - Invoking 'PrivacyDashboard' iOS SDK
    public static func showPrivacyDashboard(withApiKey: String, withUserId: String, withOrgId: String, withBaseUrl: String, accessToken: String = "", turnOnAskme: Bool, turnOnUserRequest: Bool, turnOnAttributeDetail: Bool) {
        BBConsentPrivacyDashboardiOS.shared.turnOnUserRequests = turnOnUserRequest
        BBConsentPrivacyDashboardiOS.shared.turnOnAskMeSection = turnOnAskme
        BBConsentPrivacyDashboardiOS.shared.turnOnAttributeDetailScreen = turnOnAttributeDetail
        BBConsentPrivacyDashboardiOS.shared.baseUrl = withBaseUrl
        BBConsentPrivacyDashboardiOS.shared.show(organisationId: withOrgId, apiKey: withApiKey, userId: withUserId, accessToken: accessToken)
    }
    
    public static func showDataSharingUI(apiKey: String, userId: String, accessToken: String? = nil, baseUrlString: String, dataAgreementId: String, organisationName: String, organisationLogoImageUrl: String, termsOfServiceText : String, termsOfServiceUrl: String, cancelButtonText: String) {
        let frameworkBundle = Bundle(for: BBConsentOrganisationViewController.self)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("PrivacyDashboardiOS.bundle")
        var storyboard = UIStoryboard()
        if let resourceBundle = Bundle(url: bundleURL!) {
            storyboard = UIStoryboard(name: "PrivacyDashboard", bundle: resourceBundle)
        } else {
            let myBundle = Bundle(for: BBConsentOrganisationViewController.self)
            storyboard = UIStoryboard(name: "PrivacyDashboard", bundle: myBundle)
        }
        // Passing Auth info
        BBConsentPrivacyDashboardiOS.shared.userId = userId
        BBConsentPrivacyDashboardiOS.shared.accessToken = accessToken
        let sharingVC = storyboard.instantiateViewController(withIdentifier: "BBConsentDataSharingVC") as? BBConsentDataSharingVC ?? BBConsentDataSharingVC()
        // Passing other required info
        let data = apiKey.data(using: .utf8) ?? Data()
        _ = BBConsentKeyChainUtils.save(key: "BBConsentApiKey", data: data)
        BBConsentPrivacyDashboardiOS.shared.baseUrl = baseUrlString
        
        sharingVC.dataAgreementId = dataAgreementId
        sharingVC.theirOrgName = organisationName
        sharingVC.theirLogoImageUrl = organisationLogoImageUrl
        sharingVC.termsOfServiceText = termsOfServiceText
        sharingVC.termsOFServiceUrl = termsOfServiceUrl
        sharingVC.cancelButtonText = cancelButtonText
        sharingVC.sendDataBack = { data in
            debugPrint(data)
            self.receiveDataBackFromPrivacyDashboard?(data)
        }
        
        readDataAgreementRecordApi(dataAgreementId: dataAgreementId) { success, resultVal in
            if resultVal["errorCode"] as? Int != 500 && !(resultVal["consentRecord"] is NSNull) {
                // If existing record found for the data agreement ID (status code will be !500)
                // Return the records reponse
                self.receiveDataBackFromPrivacyDashboard?(resultVal)
            } else {
                // If no record found for the data agreement ID (status code will be 500)
                // Navigate to Data sharing UI screen
                let navVC = UINavigationController.init(rootViewController: sharingVC)
                navVC.modalPresentationStyle = .fullScreen
                UIApplication.topViewController()?.present(navVC, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Read data agreement api call
    private static func readDataAgreementRecordApi(dataAgreementId: String, completionBlock:@escaping (_ success: Bool, _ resultVal: [String: Any]) -> Void){
        BBConsentBaseWebService.shared.makeAPICall(urlString: Constant.URLStrings.fetchDataAgreement + dataAgreementId, parameters: [:], method: .get) { success, resultVal in
            if success {
                debugPrint(resultVal)
                completionBlock(true, resultVal)
            } else {
                debugPrint(resultVal)
                completionBlock(false, resultVal)
            }
        }
    }
    // MARK: - 'Individual' related api calls
    public static func createAnIndividual(id:String?, externalId:String?, externalIdType: String?, identityProviderId: String?, name: String, iamId: String?, email: String, phone:String, completionBlock:@escaping (_ success: Bool, _ resultVal: [String: Any]) -> Void) {
        let individual = Individual(id: id, externalID: externalId, externalIDType: externalId, identityProviderID: identityProviderId, name: name, iamID: iamId, email: email, phone: phone)
        let record = IndividualRecord(individual: individual)
        let data = try! JSONEncoder.init().encode(record)
        let dictionary = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
        
        BBConsentBaseWebService.shared.makeAPICall(urlString: Constant.URLStrings.createIndividual, parameters: dictionary, method: .post) { success, resultVal in
            if success {
                debugPrint(resultVal)
                completionBlock(true, resultVal)
                
            } else {
                debugPrint(resultVal)
                completionBlock(false, resultVal)
            }
        }
    }
    
    public static func readAnIndividual(individualId: String,  completionBlock:@escaping (_ success: Bool, _ resultVal: [String: Any]) -> Void) {
        BBConsentBaseWebService.shared.makeAPICall(urlString: Constant.URLStrings.readIndividual + individualId, parameters: [:], method: .get) { success, resultVal in
            if success {
                debugPrint(resultVal)
                completionBlock(true, resultVal)
            } else {
                debugPrint(resultVal)
                completionBlock(false, resultVal)
            }
        }
    }
    
    public static func updateAnIndividual(individualId: String, externalId:String?, externalIdType: String?, identityProviderId: String?, name: String, iamId: String?, email: String, phone:String, completionBlock:@escaping (_ success: Bool, _ resultVal: [String: Any]) -> Void) {
        let individual = Individual(id: individualId, externalID: externalId, externalIDType: externalId, identityProviderID: identityProviderId, name: name, iamID: iamId, email: email, phone: phone)
        let record = IndividualRecord(individual: individual)
        let data = try! JSONEncoder.init().encode(record)
        let dictionary = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
        
        BBConsentBaseWebService.shared.makeAPICall(urlString: Constant.URLStrings.readIndividual + individualId, parameters: dictionary ,method: .put) { success, resultVal in
            if success {
                debugPrint(resultVal)
                completionBlock(true, resultVal)
            } else {
                debugPrint(resultVal)
                completionBlock(false, resultVal)
            }
        }
    }
    
    public static func fetchAllIndividuals(completionBlock:@escaping (_ success: Bool, _ resultVal: [String: Any]) -> Void) {
        BBConsentBaseWebService.shared.makeAPICall(urlString: Constant.URLStrings.fetchAllIndividuals, parameters: [:] ,method: .get) { success, resultVal in
            if success {
                debugPrint(resultVal)
                completionBlock(true, resultVal)
            } else {
                debugPrint(resultVal)
                completionBlock(false, resultVal)
            }
        }
    }
}
