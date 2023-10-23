//
//	Organization.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

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
        descriptionField = json["Description"].stringValue
        iD = json["ID"].stringValue
        imageURL = json["ImageURL"].url
        logoImageURL = json["LogoImageURL"].url
        coverImageURL = json["CoverImageURL"].url
        privacyPolicy = json["PolicyURL"].stringValue
        location = json["Location"].stringValue
        name = json["Name"].stringValue
        
        let typeJson = json["Type"]
        if !typeJson.isEmpty{
            type = OrgType(fromJson: typeJson)
        }
        if let orgID = json["OrgID"].string{
            iD = orgID
        }
        if let typeVal = json["Type"].string{
            type = OrgType.init(fromJson: typeJson)
            type?.type = typeVal
        }
        if let typeId = json["TypeID"].string{
            type?.iD = typeId
        }
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
