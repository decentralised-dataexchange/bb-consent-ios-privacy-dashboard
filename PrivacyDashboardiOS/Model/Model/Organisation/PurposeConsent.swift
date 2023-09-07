//
//	PurposeConsent.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class PurposeConsent {

	var count : Count!
	var purpose : Purpose!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!) {
		if json.isEmpty{
			return
		}
		let countJson = json["Count"]
		if !countJson.isEmpty{
			count = Count(fromJson: countJson)
		}
		let purposeJson = json["Purpose"]
		if !purposeJson.isEmpty{
			purpose = Purpose(fromJson: purposeJson)
		}
	}
}
