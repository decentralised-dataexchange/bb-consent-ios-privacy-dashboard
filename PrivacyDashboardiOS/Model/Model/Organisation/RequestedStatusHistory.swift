//
//  RequestedStatusHistory.swift
//  iGrant
//
//  Created by Mohamed Rebin on 08/07/19.
//  Copyright © 2019 iGrant.com. All rights reserved.
//

import Foundation
import SwiftyJSON
class RequestedStatusHistory {
    var DataRequests: [RequestStatus]!
    var IsRequestsOngoing: Bool?
    var IsDataDeleteRequestOngoing: Bool?
    var IsDataDownloadRequestOngoing: Bool?
    var links: Link!

    var isActiveDeleteDataShown = false
    var isActiveDownloadDataShown = false
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        let linksJson = json["Links"]
        if !linksJson.isEmpty {
            links = Link(fromJson: linksJson)
        }
        IsRequestsOngoing = json["IsRequestsOngoing"].boolValue
        IsDataDeleteRequestOngoing = json["IsDataDeleteRequestOngoing"].boolValue
        IsDataDownloadRequestOngoing = json["IsDataDownloadRequestOngoing"].boolValue
        DataRequests = [RequestStatus]()
        let DataRequestsArray = json["DataRequests"].arrayValue
        for DataRequestJson in DataRequestsArray {
            let value = RequestStatus(fromJson: DataRequestJson)
            if value.type == 1 {
                if (IsDataDeleteRequestOngoing ?? false) && !isActiveDeleteDataShown {
                    value.isActiveRequest = true
                    isActiveDeleteDataShown = true
                }
            } else if value.type == 2 {
                if (IsDataDownloadRequestOngoing ?? false) && !isActiveDownloadDataShown {
                    value.isActiveRequest = true
                    isActiveDownloadDataShown = true
                }
            }
            DataRequests.append(value)
        }
    }
}
