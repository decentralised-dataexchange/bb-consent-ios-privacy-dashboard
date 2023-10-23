//
//	ConsentListing.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class ConsentListingResponse: ConsentListingResponseWrapper {
	var consentID : String?
	var consents : PurposeDetails?
	var iD : String?
	var orgID : String?
	var userID : String?

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		consentID = json["ConsentID"].stringValue
		let consentsJson = json["Consents"]
		if !consentsJson.isEmpty{
			consents = PurposeDetails(fromJson: consentsJson)
		}
		iD = json["ID"].stringValue
		orgID = json["OrgID"].stringValue
		userID = json["UserID"].stringValue
	}
}


protocol ConsentListingResponseWrapper {
    var consentID : String? { get }
    var consents : PurposeDetails? { get }
    var iD : String? { get }
    var orgID : String? { get }
    var userID : String? { get }
}
