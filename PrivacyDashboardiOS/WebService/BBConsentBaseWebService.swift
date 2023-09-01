//
//  BBConsentBaseWebService.swift
//  PrivacyDashboardiOS
//
//  Created by Mumthasir mohammed on 31/08/23.
//

import Foundation
import Alamofire
import SwiftyJSON

//Production Url
//var baseUrl = "https://api.igrant.io/v1/"

//Staging Url
var baseUrl = "https://staging-api.igrant.io/v1/"
var baseUrl_V1 = "https://staging-api.igrant.io/v1.1/"

//Demo Url
//var baseUrl = "https://demo-api.igrant.io/v1/"
//var baseUrl_V1 = "https://demo-api.igrant.io/v1.1/"

class RestResponse : NSObject {
    var response : JSON?
    var responseModel : AnyObject?
    var responseCode : Int?
    var responseHttpCode : Int?
    var responseDetail : AnyObject?
    var error : Error?
    var paginationIndex : NSMutableString?
    var requestData : AnyObject?
    var message : String?
    var serviceType = WebServiceType.None
}

class MultipartData: NSObject {
    var data: NSData
    var name: String
    var fileName: String
    var mimeType: String
    init(data: NSData, name: String, fileName: String, mimeType: String) {
        self.data = data
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
    }
}

@objc protocol BaseServiceDelegates {
    // The service call was successful and the data is passed to the manager
    @objc optional func didSuccessfullyReceiveData(response:RestResponse?)
    // The service call was failed and the error message to be shown is fetched and returned to the manager.
    @objc optional func didFailedToReceiveData(response:RestResponse?)
    @objc optional func imageUploadPrograss(prograssValue : Float)
}

enum WebServiceType {
    case None
    case ReCallLogin
}

class BBConsentBaseWebService: NSObject {
    var serviceType = WebServiceType.None
    var delegate : BaseServiceDelegates?
    var url: String?
    var parameters = [String: AnyObject]()
    var uploadData: [MultipartData]?
    var header:[String : String]?
    var requestInfo : [String:String]?
    var errorMsg : String?
    
    
    func refreshToken() {
        let refreshToken : String = (UserInfo.currentUser()?.refreshToken)!
        self.parameters =  ["clientId": "igrant-ios-app" as AnyObject, "refreshToken": refreshToken as AnyObject]
        self.url = baseUrl + "user/token"
        self.postServiceCall()
    }

    func failureWithError(error: Error?) {
        let restResponse = RestResponse()
        restResponse.error = error
        restResponse.message = errorMsg
        restResponse.serviceType = self.serviceType
        delegate?.didFailedToReceiveData!(response: restResponse)
    }
    
    func successWithResponse(response:JSON?) {
        let restResponse = RestResponse()
        restResponse.response = response
        restResponse.serviceType = self.serviceType
        restResponse.requestData = self.requestInfo as AnyObject?
        delegate?.didSuccessfullyReceiveData!(response: restResponse)
    }

    func getServiceCall() {
        if UserInfo.currentUser()?.token != nil{
            let token : String = (UserInfo.currentUser()?.token)!
            let hearDict = ["Authorization":"Bearer \(token)"]
            header = hearDict
        }else{
            header = nil
        }
        
        if let tokendata = BBConsentKeyChainUtils.load(key: "BBConsentToken") {
            let token = String(data: tokendata, encoding: .utf8) ?? ""
            let hearDict = ["Authorization":"ApiKey \(token)"]
            header = hearDict
        }
        
        AF.request(url!, parameters: parameters, headers:HTTPHeaders.init(header ?? [:]))
            .validate()
            .responseJSON { response in
                switch response.result{
                case .success(let value):
                    //                    if let val = response.result.value {
                    let json = JSON(value)
                    self.successWithResponse(response: json)
                    //                    }
                case .failure(let error):
                    if let data = response.data, let utf8Text = String.init(data: data, encoding: String.Encoding.utf8) {
                        print("Data: \(utf8Text)")
                    }
                    let json = JSON(response.data as Any)
                    if let errormsg = json["error_description"].string{
                        self.errorMsg = errormsg
                    }
                    if let errormsg = json["Message"].string{
                        self.errorMsg = errormsg
                    }
                    self.failureWithError(error: error)
                }
            }
    }
    
    func postUploadServiceCall() {
        if let data = uploadData {
            self.upload(data: data)
        }
        else {
            postServiceCall()
        }
    }
    
    
    func postServiceCall() {
        if UserInfo.currentUser()?.token != nil{
            let token : String  = (UserInfo.currentUser()?.token)!
            let hearDict = ["Authorization":"Bearer \(token)"]
            header = hearDict
        }else{
            header = nil
        }
        
        if let tokendata = BBConsentKeyChainUtils.load(key: "BBConsentToken") {
            let token = String(data: tokendata, encoding: .utf8) ?? ""
            let hearDict = ["Authorization":"ApiKey \(token)"]
            header = hearDict
        }
        
        if serviceType == .ReCallLogin{
            header = nil
        }
        AF.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default , headers:HTTPHeaders.init(header ?? [:]))
            .validate()
            .responseJSON { response in
                switch response.result{
                case .success(let value):
                    //                    if let val = response.result.value {
                    let json = JSON(value)
                    self.successWithResponse(response: json)
                    //                    }
                case .failure(let error):
                    if let data = response.data, let utf8Text = String.init(data: data, encoding: String.Encoding.utf8) {
                        print("Data: \(utf8Text)")
                    }
                    let json = JSON(response.data as Any)
                    if let errormsg = json["error_description"].string{
                        self.errorMsg = errormsg
                    }
                    if let errormsg = json["Message"].string{
                        self.errorMsg = errormsg
                    }
                    self.failureWithError(error: error)
                }
            }
    }
    
    func putServiceCall() {
        if UserInfo.currentUser()?.token != nil{
            let token : String  = (UserInfo.currentUser()?.token)!
            let hearDict = ["Authorization":"Bearer \(token)"]
            header = hearDict
        }else{
            header = nil
        }
        
        if let tokendata = BBConsentKeyChainUtils.load(key: "BBConsentToken") {
            let token = String(data: tokendata, encoding: .utf8) ?? ""
            let hearDict = ["Authorization":"ApiKey \(token)"]
            header = hearDict
        }
        
        AF.request(url!, method: .put, parameters: parameters,  encoding: JSONEncoding.default, headers:HTTPHeaders.init(header ?? [:]))
            .validate()
            .responseJSON { response in
                switch response.result{
                case .success(let value):
                    //                    if let val = response.result.value {
                    let json = JSON(value)
                    self.successWithResponse(response: json)
                    //                    }
                case .failure(let error):
                    if let data = response.data, let utf8Text = String.init(data: data, encoding: String.Encoding.utf8) {
                        print("Data: \(utf8Text)")
                    }
                    let json = JSON(response.data as Any)
                    if let errormsg = json["error_description"].string{
                        self.errorMsg = errormsg
                    }
                    if let errormsg = json["Message"].string{
                        self.errorMsg = errormsg
                    }
                    self.failureWithError(error: error)
                }
            }
    }
    
    
    func patchServiceCall() {
        if UserInfo.currentUser()?.token != nil{
            let token : String  = (UserInfo.currentUser()?.token)!
            let hearDict = ["Authorization":"Bearer \(token)"]
            
            header = hearDict
        }else{
        }
        if let tokendata = BBConsentKeyChainUtils.load(key: "BBConsentToken") {
            let token = String(data: tokendata, encoding: .utf8) ?? ""
            let hearDict = ["Authorization":"ApiKey \(token)"]
            header = hearDict
        }
        
        AF.request(url!, method: .patch, parameters: parameters, encoding: JSONEncoding.default,headers:HTTPHeaders.init(header ?? [:])
        )
        .validate()
        .responseJSON {response in
            switch response.result{
            case .success(let value):
                //                    if let val = response.result.value {
                let json = JSON(value)
                self.successWithResponse(response: json)
                //                    }
            case .failure(let error):
                if let data = response.data, let utf8Text = String.init(data: data, encoding: String.Encoding.utf8) {
                    print("Data: \(utf8Text)")
                }
                let json = JSON(response.data as Any)
                if let errormsg = json["error_description"].string{
                    self.errorMsg = errormsg
                }
                if let errormsg = json["Message"].string{
                    self.errorMsg = errormsg
                }
                self.failureWithError(error: error)
            }
        }
    }
    
    
    func deleteServiceCall() {
        if UserInfo.currentUser()?.token != nil{
            let token : String  = (UserInfo.currentUser()?.token)!
            let hearDict = ["Authorization":"Bearer \(token)"]
            header = hearDict
        }else{
            header = nil
        }
        if let tokendata = BBConsentKeyChainUtils.load(key: "BBConsentToken") {
            let token = String(data: tokendata, encoding: .utf8) ?? ""
            let hearDict = ["Authorization":"ApiKey \(token)"]
            header = hearDict
        }
        
        AF.request(url!, method: .delete, headers:HTTPHeaders.init(header ?? [:]))
            .validate()
            .responseJSON { response in
                switch response.result{
                case .success(let value):
                    //                    if let val = value {
                    let json = JSON(value as Any)
                    self.successWithResponse(response: json)
                    //                    }
                case .failure(let error):
                    let json = JSON(response.data as Any)
                    if let errormsg = json["error_description"].string{
                        self.errorMsg = errormsg
                    }
                    if let errormsg = json["Message"].string{
                        self.errorMsg = errormsg
                    }
                    self.failureWithError(error: error)
                }
            }
    }
    
    func upload(data: [MultipartData]) {
        if UserInfo.currentUser()?.token != nil{
            let token : String  = (UserInfo.currentUser()?.token)!
            let hearDict = ["Authorization":"Bearer \(token)"]
            header = hearDict
        }else{
            header = nil
        }
        if let tokendata = BBConsentKeyChainUtils.load(key: "BBConsentToken") {
            let token = String(data: tokendata, encoding: .utf8) ?? ""
            let hearDict = ["Authorization":"ApiKey \(token)"]
            header = hearDict
        }
        
        let urlRequest = try! URLRequest(url: url!, method: .post, headers: HTTPHeaders.init(header ?? [:]))
        AF.upload(multipartFormData: { multipartFormData in
            for (key,value) in self.parameters {
                if let valueString = value as? String {
                    multipartFormData.append(valueString.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            for data in self.uploadData! {
                multipartFormData.append(data.data as Data, withName: data.name, fileName: data.fileName, mimeType: data.mimeType)
            }
        }, to: url!).responseJSON { (encodingResult) in
            switch encodingResult.result {
            case .success(let value):
                //                upload.responseJSON { response in
                debugPrint(value)
                let json = JSON(value as Any)
                self.successWithResponse(response: json)
                //                }
            case .failure(let encodingError):
                print(encodingError)
                self.failureWithError(error: encodingError)
            }
        }
    }
}
