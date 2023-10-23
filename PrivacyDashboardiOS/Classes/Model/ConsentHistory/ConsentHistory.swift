//
//	ConsentHistory.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class ConsentHistory: ConsentHistoryWrapper {
	var iD : String?
	var log : String?
	var orgID : String?
	var purposeID : String?
	var timeStamp : String?

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		iD = json["ID"].stringValue
		log = json["Log"].stringValue
		orgID = json["OrgID"].stringValue
		purposeID = json["PurposeID"].stringValue
		timeStamp = json["TimeStamp"].stringValue
	}
}

protocol ConsentHistoryWrapper {
    var iD : String? { get }
    var log : String? { get }
    var orgID : String? { get }
    var purposeID : String? { get }
    var timeStamp : String? { get }
}
