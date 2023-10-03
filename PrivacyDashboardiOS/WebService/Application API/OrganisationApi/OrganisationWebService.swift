
//
//  OrganisationWebService.swift
//  iGrant
//
//  Created by Ajeesh T S on 25/03/18.
//  Copyright © 2018 iGrant.com. All rights reserved.
//

import UIKit

enum RequestType {
    case DownloadData
    case ForgetMe
}

class OrganisationWebService: BBConsentBaseWebService {
    
    func nonAddedOrganisationList(){
        self.url = baseUrl + "GetOrgsToSubscribe"
        getServiceCall()
    }
    
    func getSubscribedOrgnaisationList(categoryId : String){
        self.url = baseUrl + "GetUserOrgsAndSuggestionsByType" + "?typeID=" + categoryId
        getServiceCall()
    }
    
    func getSubscribedOrgs(){
        self.url = baseUrl + "user/organizations"
        getServiceCall()
    }
    
    func organisationDetails(orgId : String){
        let userID = BBConsentPrivacyDashboardiOS.shared.userId ?? ""
        self.url = baseUrl + "GetUserOrgsAndConsents" + "?orgID=" + orgId
        getServiceCall()
    }
    
    func addOrganisation(orgId : String, subKey: String?){
//        var userId  =  ""
//        if  UserInfo.currentUser()?.userID != nil{
//            userId =  (UserInfo.currentUser()?.userID)!
//        }
        let userID = BBConsentPrivacyDashboardiOS.shared.userId ?? ""
        self.url = baseUrl + "organizations/" + orgId + "/users"
        self.parameters = ["UserID": userID as AnyObject, "SubscribeKey" : subKey ?? ""] as [String : AnyObject]
        postServiceCall()
    }
    
    func getOrganisationSubscribeMethod(orgId : String) {
        self.url = baseUrl + "organizations/" + orgId + "/subscribe-method"
        getServiceCall()
    }
    
    func removeOrganisation(orgId : String){
//        var userId  =  ""
//        if  UserInfo.currentUser()?.userID != nil{
//            userId =  (UserInfo.currentUser()?.userID)!
//        }
        let userID = BBConsentPrivacyDashboardiOS.shared.userId ?? ""
        self.url = baseUrl + "organizations/" + orgId + "/users/" + userID
        deleteServiceCall()
    }
    
    func allowAllConsent(orgId : String){
//        var userId  =  ""
//        if  UserInfo.currentUser()?.userID != nil{
//            userId =  (UserInfo.currentUser()?.userID)!
//        }
        let userID = BBConsentPrivacyDashboardiOS.shared.userId ?? ""
        self.url = baseUrl + "UpdateAllConsents/" + userID + "?orgID=" + orgId + "&consented=Disallow"
        postServiceCall()
    }
    
    func searchOrg(input : String,typeId : String?){
//        var userId  =  ""
//        if  UserInfo.currentUser()?.userID != nil{
//            userId =  (UserInfo.currentUser()?.userID)!
//        }
        let userID = BBConsentPrivacyDashboardiOS.shared.userId ?? ""
        let urlString = baseUrl + "organizations/" + "search?name=" + input
        if typeId != nil{
            let orgTypeID : String = typeId!
            self.url = urlString + "&type=" + orgTypeID + "&userID=" + userID
            
        }else{
            self.url = urlString + "&userID=" + userID
        }
        getServiceCall()
    }
    
    func changeConsent(orgId : String,consentID : String,parameter:[String: AnyObject]){
//        var userId  =  ""
//        if  UserInfo.currentUser()?.userID != nil{
//            userId =  (UserInfo.currentUser()?.userID)!
//        }
        let userID = BBConsentPrivacyDashboardiOS.shared.userId ?? ""
        self.url = baseUrl + "organizations/" + orgId + "/users/" + userID + "/consents/" + consentID
        self.parameters = parameter
        self.parameters.updateValue(consentID as AnyObject, forKey: "consentID")
        patchServiceCall()
    }

    func requestDownloadData(orgId: String) {
        let userID = BBConsentPrivacyDashboardiOS.shared.userId ?? ""
//        self.url = baseUrl + "user/organizations/" + orgId + "/data-download"
        self.url = baseUrl + "users/" + userID + "/organizations/" + orgId + "/data-download"
        postServiceCall()
    }
    
    func requestForgetMe(orgId: String) {
        let userID = BBConsentPrivacyDashboardiOS.shared.userId ?? ""
        self.url = baseUrl + "users/" + userID + "/organizations/" + orgId + "/data-delete"
        postServiceCall()
    }
    
    func getDownloadDataStatus(orgId: String) {
        self.url = baseUrl + "user/organizations/" + orgId + "/data-download/status"
        getServiceCall()
    }
    
    func acceptEulaConsent(orgId: String, parameters : [String: AnyObject]) {
        self.url = baseUrl + "user/organizations/" + orgId + "/eula"
        self.parameters = parameters
        postServiceCall()
    }
    
    func getForgetMeStatus(orgId: String) {
        self.url = baseUrl + "user/organizations/" + orgId + "/data-delete/status"
        getServiceCall()
    }
    
    func cancelRequest(orgId: String, requestID: String, type: RequestType) {
        let userID = BBConsentPrivacyDashboardiOS.shared.userId ?? ""
        if type == RequestType.DownloadData {
             self.url = baseUrl + "users/" + userID + "/organizations/" + orgId + "/data-download/" + requestID + "/cancel"
        } else {
            self.url = baseUrl + "users/" + userID + "/organizations/" + orgId + "/data-delete/" + requestID + "/cancel"
        }
       postServiceCall()
    }
    
    func getRequestedStatus(orgId: String) {
        self.url = baseUrl + "user/organizations/" + orgId + "/data-status"
        getServiceCall()
    }
    
    func requestedStatusLoadMore(apiUrl : String){
        self.url = apiUrl
        getServiceCall()
    }
    
}
