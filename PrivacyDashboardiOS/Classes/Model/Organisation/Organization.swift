//
//    Organization.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON

class Organization: OrganizationWrapper {
    var descriptionField : String?
    var iD : String?
    var imageURL : URL?
    var location : String?
    var name : String?
    var type : OrgTypeWrapper?
    var logoImageURL : URL?
    var coverImageURL : URL?
    var privacyPolicy: String?
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!) {
        if json.isEmpty{
            return
        }
        descriptionField = json["organisation"]["description"].stringValue
        iD = json["organisation"]["id"].stringValue
        imageURL = json["organisation"]["ImageURL"].url
        logoImageURL = json["organisation"]["logoImageUrl"].url
        coverImageURL = json["organisation"]["coverImageUrl"].url
        privacyPolicy = json["organisation"]["policyUrl"].stringValue
        location = json["organisation"]["location"].stringValue
        name = json["organisation"]["name"].stringValue
    }
}

protocol OrganizationWrapper {
    var descriptionField : String? { get }
    var iD : String? { get }
    var imageURL : URL? { get }
    var location : String? { get }
    var name : String? { get }
    var type : OrgTypeWrapper? { get }
    var logoImageURL : URL? { get }
    var coverImageURL : URL? { get }
    var privacyPolicy: String? { get }
}
