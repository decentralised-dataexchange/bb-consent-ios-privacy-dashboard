//
//	PurposeConsent.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class PurposeConsent: PurposeConsentWrapperV2 {
    var active: Bool?
    var count : Count?
    var descriptionField : String?
    var iD : String?
    var lawfulUsage : Bool?
    var policyURL : String?
    var name: String?
    var dataAttributes: [DataAttribute]?

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!) {
		if json.isEmpty{
			return
		}
        descriptionField = json["purposeDescription"].stringValue
        iD = json["id"].stringValue
        lawfulUsage = (json["lawfulBasis"] == "consent" || json["lawfulBasis"] == "legitimate_interest")
        policyURL = json["policy"]["url"].stringValue
        name = json["purpose"].stringValue
        active = json["active"].boolValue
        
        let dataAttributesArray = json["dataAttributes"].arrayValue
        dataAttributes = [DataAttribute]()
        for dataAttribute in dataAttributesArray{
            let value = DataAttribute(fromJson: dataAttribute)
            dataAttributes?.append(value)
        }
	}
}

protocol PurposeConsentWrapper {
    var count : Count? { get }
    var purpose : Purpose? { get }
}

protocol PurposeConsentWrapperV2 {
    var count : Count? { get }
    var descriptionField : String? { get }
    var iD : String? { get }
    var lawfulUsage : Bool? { get }
    var policyURL : String? { get }
    var name: String? { get }
    var dataAttributes: [DataAttribute]? { get }
    var active: Bool? { get }
}
