//
//	ConsentHistoryData.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class ConsentHistoryData{

	var consentHistory : [ConsentHistory]!
	var links : Link!
    var unReadCount : Int!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		consentHistory = [ConsentHistory]()
		let consentHistoryArray = json["ConsentHistory"].arrayValue
		for consentHistoryJson in consentHistoryArray{
			let value = ConsentHistory(fromJson: consentHistoryJson)
			consentHistory.append(value)
		}
		unReadCount = json["UnReadCount"].intValue
        let linksJson = json["Links"]

		if !linksJson.isEmpty{
			links = Link(fromJson: linksJson)
		}
	}

}
