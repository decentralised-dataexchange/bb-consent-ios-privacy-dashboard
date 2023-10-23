//
//  OrganisationWebServiceManager.swift
//  iGrant
//
//  Created by Ajeesh T S on 25/03/18.
//  Copyright © 2018 iGrant.com. All rights reserved.
//

import UIKit

enum OrganizationApiType {
    case NonAddedOrgList
    case AddNewOrg
    case OrgDetails
    case RemoveOrg
    case AllowAlConsent
    case UpdateConsent
    case PurposeList
    case UpdatePurpose
    case requestDownloadData
    case requestForgetMe
    case getDownloadDataStatus
    case getForgetMeStatus
    case cancelRequest
    case getRequestedStatus
    case acceptEula
}

class WebServiceTaskManager: NSObject {
    var managerDelegate : WebServiceTaskManagerProtocol?
    deinit {
        self.managerDelegate = nil
    }
    
}

class OrganisationWebServiceManager: WebServiceTaskManager {
    var serviceType = OrganizationApiType.NonAddedOrgList
    let searchService = OrganisationWebService()
    var organisationId = ""
    var organisationType : String?
    var searchOrganisationInputStr = ""
    var consentDictionary = [String: AnyObject]()
    var consentId = ""
    var subscriptionKey = ""
    var requestId = ""
    var requestType = RequestType.DownloadData
    var isLoadMore = false
    
    func refreshToken(){
        let service = BBConsentBaseWebService()
        service.delegate = self
        service.serviceType = .ReCallLogin
        service.refreshToken()
    }
    
    func getNonAddedOrganisationList(){
        serviceType = .NonAddedOrgList
        DispatchQueue.global().async {
            self.searchService.delegate = self
            self.searchService.nonAddedOrganisationList()
        }
    }
    
    func getOrganisationDetails(orgId : String){
        serviceType = .OrgDetails
        organisationId = orgId
        DispatchQueue.global().async {
            self.searchService.delegate = self
            self.searchService.organisationDetails(orgId: orgId)
        }
    }
    
    func consentNewOrganisation(orgId : String, subKey: String?){
        organisationId = orgId
        serviceType = .AddNewOrg
        subscriptionKey = subKey ?? ""
        DispatchQueue.global().async {
            self.searchService.delegate = self
            self.searchService.addOrganisation(orgId: orgId, subKey: subKey)
        }
    }
    
    func consentList(orgId : String,purposeId:String,consentId : String ){
        organisationId = orgId
        serviceType = .PurposeList
        DispatchQueue.global().async {
            self.searchService.delegate = self
            //        var userId  =  ""
            //        if  UserInfo.currentUser()?.userID != nil{
            //            userId =  (UserInfo.currentUser()?.userID)!
            //        }
            let userID = BBConsentPrivacyDashboardiOS.shared.userId ?? ""
            let urlPart = "/consents/" + consentId + "/purposes/" + purposeId
            self.searchService.url = baseUrl + "organizations/" + orgId + "/users/" + userID + urlPart
            self.searchService.getServiceCall()
        }
    }
    
    func removeOrganisation(orgId : String){
        organisationId = orgId
        serviceType = .RemoveOrg
        DispatchQueue.global().async {
            self.searchService.delegate = self
            self.searchService.removeOrganisation(orgId: orgId)
        }
    }
    
    func allowAllConsentOfOrganisation(orgId : String){
        organisationId = orgId
        serviceType = .AllowAlConsent
        DispatchQueue.global().async {
            self.searchService.delegate = self
            self.searchService.allowAllConsent(orgId: orgId)
        }
    }
  
    func updateConsent(orgId : String,consentID : String,attributeId : String,purposeId:String,valuesDict:[String: AnyObject]){
        organisationId = orgId
        serviceType = .UpdateConsent
        consentId = consentID
        consentDictionary = valuesDict
        DispatchQueue.global().async {
            self.searchService.delegate = self
            //        var userId  =  ""
            //        if  UserInfo.currentUser()?.userID != nil{
            //            userId =  (UserInfo.currentUser()?.userID)!
            //        }
            let userID = BBConsentPrivacyDashboardiOS.shared.userId ?? ""
            let urlPart = "/consents/" + consentID + "/purposes/" + purposeId + "/attributes/" + attributeId
            self.searchService.url = baseUrl + "organizations/" + orgId + "/users/" + userID + urlPart
            self.searchService.parameters = valuesDict
            self.searchService.patchServiceCall()
//            self.searchService.changeConsent(orgId: orgId, consentID: consentID, parameter: valuesDict)
        }
    }
    
    
    func updatePurpose(orgId : String,consentID : String,attributeId : String,purposeId:String,status:String){
            organisationId = orgId
            serviceType = .AllowAlConsent
            consentId = consentID
            DispatchQueue.global().async {
                self.searchService.delegate = self
                //        var userId  =  ""
                //        if  UserInfo.currentUser()?.userID != nil{
                //            userId =  (UserInfo.currentUser()?.userID)!
                //        }
                let userID = BBConsentPrivacyDashboardiOS.shared.userId ?? ""
                let urlPart = "/consents/" + consentID + "/purposes/" + purposeId + "/status"
                self.searchService.url = baseUrl + "organizations/" + orgId + "/users/" + userID + urlPart
                self.searchService.parameters = ["consented" : status as AnyObject]
                self.searchService.postServiceCall()
                //            self.searchService.changeConsent(orgId: orgId, consentID: consentID, parameter: valuesDict)
            }
    }
        
        func requestDownloadData(orgId : String){
            serviceType = .requestDownloadData
            organisationId = orgId
            DispatchQueue.global().async {
                self.searchService.delegate = self
                self.searchService.requestDownloadData(orgId: orgId)
            }
        }
        
        func requestForgetMe(orgId : String){
            serviceType = .requestForgetMe
            organisationId = orgId
            DispatchQueue.global().async {
                self.searchService.delegate = self
                self.searchService.requestForgetMe(orgId: orgId)
            }
        }
    
    func acceptEulaConsent(orgId : String, parameters: [String : AnyObject]){
        serviceType = .acceptEula
        consentDictionary = parameters
        organisationId = orgId
        DispatchQueue.global().async {
            self.searchService.delegate = self
            self.searchService.acceptEulaConsent(orgId: orgId, parameters: parameters)
        }
    }
        
        func getDownloadDataStatus(orgId : String){
        serviceType = .getDownloadDataStatus
        organisationId = orgId
        DispatchQueue.global().async {
        self.searchService.delegate = self
        self.searchService.getDownloadDataStatus(orgId: orgId)
        }
        }
        
        func getForgetMeStatus(orgId : String){
        serviceType = .getForgetMeStatus
        organisationId = orgId
        DispatchQueue.global().async {
        self.searchService.delegate = self
        self.searchService.getForgetMeStatus(orgId: orgId)
        }
        }
    
    func cancelRequest(orgId : String, requestId: String, type: RequestType ){
        serviceType = .cancelRequest
        organisationId = orgId
        self.requestId = requestId
        self.requestType = type
        DispatchQueue.global().async {
            self.searchService.delegate = self
            self.searchService.cancelRequest(orgId: orgId, requestID: requestId, type: type)
        }
    }
    
    func getRequestedStatus(orgId: String) {
        serviceType = .getRequestedStatus
        organisationId = orgId
        DispatchQueue.global().async {
            self.searchService.delegate = self
            self.searchService.getRequestedStatus(orgId: orgId)
        }
    }
    
    func getRequestedStatusLoadMoreList(url:String){
        serviceType = .getRequestedStatus
        self.isLoadMore =  true
        DispatchQueue.global().async{
            let orgService = OrganisationWebService()
            orgService.delegate = self
            orgService.requestedStatusLoadMore(apiUrl: url)
        }
    }
//        https://api.igrant.dev/v1/organizations/5b2137c93fee23000194d8ea/users/5b2135a23fee23000194d8e3/consents/5b3dca30c8c87f0001322c48/purposes/5b3dc983c8c87f0001322c45/status
    
    
    func reCallFailedApi(){
        switch(serviceType) {
        case .NonAddedOrgList:getNonAddedOrganisationList()
        case .AddNewOrg: consentNewOrganisation(orgId: self.organisationId, subKey: self.subscriptionKey)
        case .OrgDetails:getOrganisationDetails(orgId: self.organisationId)
        case .RemoveOrg:removeOrganisation(orgId: self.organisationId)
        case .AllowAlConsent:allowAllConsentOfOrganisation(orgId: self.organisationId)
        case .UpdateConsent: break
//        updateConsent(orgId: organisationId, consentID: consentId, valuesDict: consentDictionary)
        case .PurposeList : break
        case .UpdatePurpose : break
        case .requestDownloadData : requestDownloadData(orgId: self.organisationId)
        case .requestForgetMe : requestForgetMe(orgId: self.organisationId)
        case .getForgetMeStatus : getForgetMeStatus(orgId: self.organisationId)
        case .getDownloadDataStatus : getDownloadDataStatus(orgId: self.organisationId)
        case .cancelRequest : cancelRequest(orgId: self.organisationId, requestId: self.requestId, type: self.requestType)
        case .getRequestedStatus : getRequestedStatus(orgId: self.organisationId)
        case .acceptEula : acceptEulaConsent(orgId: self.organisationId, parameters: self.consentDictionary)
        }
    }
    


}


extension OrganisationWebServiceManager : BaseServiceDelegates {
    func didSuccessfullyReceiveData(response:RestResponse?){
        let responseData = response!.response!
        if response?.serviceType == .ReCallLogin{
            if let accessToken = responseData["access_token"].string{
                UserInfo.currentUser()?.token = accessToken
            }
            if let refreshToken = responseData["refresh_token"].string{
                UserInfo.currentUser()?.token = refreshToken
            }
            UserInfo.currentUser()?.save()
            self.reCallFailedApi()
        }else{
            switch(serviceType) {
            case .NonAddedOrgList:handleNonAddedOrgsResponse(response: response)
            case .AddNewOrg: handleAddNewOrgResponse(response: response)
            case .OrgDetails: handleOrgDetailsResponse(response: response)
            case .RemoveOrg: handleRemoveOrgResponse(response: response)
            case .AllowAlConsent: handleAlloAllConsentResponse(response: response)
            case .UpdateConsent: handleUpdateConsentResponse(response: response)
            case .PurposeList : handleConsentListResponse(response: response)
            case .UpdatePurpose : handleUpdatePuposeResponse(response: response)
                
            case .requestDownloadData : handleRequestDownloadDataResponse(response: response)
            case .requestForgetMe : handleRequestForgetMeResponse(response: response)
            case .getForgetMeStatus : handleGetForgetMeStatusResponse(response: response)
            case .getDownloadDataStatus : handleGetDownloadDataStatusResponse(response: response)
            case .cancelRequest : handleCanceRequestResponse(response: response)
            case .getRequestedStatus : handleRequestedStatusHistory(response: response)
            case .acceptEula : handleAcceptEulaConsentResponse(response: response)
            }
        }
    }
    
    func didFailedToReceiveData(response:RestResponse?){
        if response?.message == Constant.AppSetupConstant.KTokenExpired{
            NotificationCenter.default.post(name: Notification.Name("ResetToLogin"), object: nil)
            //self.refreshToken()
        }else{
            self.managerDelegate?.didFinishTask(from: self, response: (data: response, error: response?.message))
        }
    }

}


extension OrganisationWebServiceManager {
    func handleNonAddedOrgsResponse(response:RestResponse?){
        let responseData = response!.response!
        DispatchQueue.global().async {
            if let orgs = responseData["Organizations"].array {
                var orgList = [OrganizationWrapper]()
                for org in orgs {
                    let orgObj : OrganizationWrapper = Organization(fromJson: org)
                    orgList.append(orgObj)
                }
                response?.responseModel = orgList as AnyObject?
            }
            DispatchQueue.main.async {
                self.managerDelegate?.didFinishTask(from: self, response: (data: response, error: nil))
            }
           
        }
    }
    
    func handleOrgDetailsResponse(response:RestResponse?){
        let responseData = response!.response!
        DispatchQueue.global().async {
            let orgDetails = OrganisationDetails(fromJson:responseData)
            response?.responseModel = orgDetails as AnyObject?
            DispatchQueue.main.async {
                self.managerDelegate?.didFinishTask(from: self, response: (data: response, error: nil))
            }
        }
    }
    
    func handleAddNewOrgResponse(response:RestResponse?){
//        let responseData = response!.response!
        DispatchQueue.global().async {
//            let orgDetails = OrganisationDetails(fromJson:responseData)
//            response?.responseModel = orgDetails as AnyObject?
            DispatchQueue.main.async {
                self.managerDelegate?.didFinishTask(from: self, response: (data: response, error: nil))
            }
        }
    }
    
    func handleRemoveOrgResponse(response:RestResponse?){
//        let responseData = response!.response!
        DispatchQueue.global().async {
            //            let orgDetails = OrganisationDetails(fromJson:responseData)
            //            response?.responseModel = orgDetails as AnyObject?
            DispatchQueue.main.async {
                self.managerDelegate?.didFinishTask(from: self, response: (data: response, error: nil))
            }
        }
    }
    
    func handleAlloAllConsentResponse(response:RestResponse?){
        //        let responseData = response!.response!
        DispatchQueue.global().async {
            //            let orgDetails = OrganisationDetails(fromJson:responseData)
            //            response?.responseModel = orgDetails as AnyObject?
            DispatchQueue.main.async {
                self.managerDelegate?.didFinishTask(from: self, response: (data: response, error: nil))
            }
        }
    }

    func handleUpdateConsentResponse(response:RestResponse?){
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.managerDelegate?.didFinishTask(from: self, response: (data: response, error: nil))
            }
        }
    }
    
    func handleUpdatePuposeResponse(response:RestResponse?){
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.managerDelegate?.didFinishTask(from: self, response: (data: response, error: nil))
            }
        }
    }
    
    
    
   func handleConsentListResponse(response: RestResponse?){
        let responseData = response!.response!
        let consentListinfo = ConsentListingResponse(fromJson:responseData)
        response?.responseModel = consentListinfo as AnyObject?
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.managerDelegate?.didFinishTask(from: self, response: (data: response, error: nil))
            }
        }
    }
    
    func handleRequestDownloadDataResponse(response: RestResponse?){
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.managerDelegate?.didFinishTask(from: self, response: (data: response, error: nil))
            }
        }
    }
    
    func handleAcceptEulaConsentResponse(response: RestResponse?){
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.managerDelegate?.didFinishTask(from: self, response: (data: response, error: nil))
            }
        }
    }
    
    func handleRequestForgetMeResponse(response: RestResponse?){
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.managerDelegate?.didFinishTask(from: self, response: (data: response, error: nil))
            }
        }
    }
    
    func handleGetDownloadDataStatusResponse(response: RestResponse?){
        let responseData = response!.response!
        let RequestStatusinfo = RequestStatus(fromJson:responseData)
        response?.responseModel = RequestStatusinfo as AnyObject?
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.managerDelegate?.didFinishTask(from: self, response: (data: response, error: nil))
            }
        }
    }
    
    func handleGetForgetMeStatusResponse(response: RestResponse?){
        let responseData = response!.response!
        let RequestStatusinfo = RequestStatus(fromJson:responseData)
        response?.responseModel = RequestStatusinfo as AnyObject?
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.managerDelegate?.didFinishTask(from: self, response: (data: response, error: nil))
            }
        }
    }
    
    func handleCanceRequestResponse(response: RestResponse?){
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.managerDelegate?.didFinishTask(from: self, response: (data: response, error: nil))
            }
        }
    }
    
    func handleRequestedStatusHistory(response: RestResponse?) {
        let responseData = response!.response!
        let RequestedStatusHistoryInfo = RequestedStatusHistory(fromJson:responseData)
        response?.responseModel = RequestedStatusHistoryInfo as AnyObject?
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.managerDelegate?.didFinishTask(from: self, response: (data: response, error: nil))
            }
        }
    }
    

}
