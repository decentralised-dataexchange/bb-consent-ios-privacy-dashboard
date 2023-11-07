//
//  PrivacyDashboard.swift
//  PrivacyDashboardiOS
//
//  Created by Mumthasir mohammed on 06/11/23.
//

import Foundation

public class PrivacyDashboard {
    // MARK: - Invoking 'PrivacyDashboard' iOS SDK
    public static func showPrivacyDashboard(withApiKey: String, withUserId: String, withOrgId: String, withBaseUrl: String, turnOnAske: Bool, turnOnUserRequest: Bool, turnOnAttributeDetail: Bool) {
        BBConsentPrivacyDashboardiOS.shared.turnOnUserRequests = turnOnUserRequest
        BBConsentPrivacyDashboardiOS.shared.turnOnAskMeSection = turnOnAske
        BBConsentPrivacyDashboardiOS.shared.turnOnAttributeDetailScreen = turnOnAttributeDetail
        BBConsentPrivacyDashboardiOS.shared.baseUrl = withBaseUrl
        BBConsentPrivacyDashboardiOS.shared.show(organisationId: withOrgId, apiKey: withApiKey, userId: withUserId)
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
