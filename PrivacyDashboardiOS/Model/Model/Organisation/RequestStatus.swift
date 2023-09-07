//
//  RequestStatus.swift
//  iGrant
//
//  Created by Mohamed Rebin on 19/06/19.
//  Copyright © 2019 iGrant.com. All rights reserved.
//

import Foundation
import SwiftyJSON

class RequestStatus {
    
    var RequestOngoing : Bool!
    var iD : String!
     var State : Int!
     var StateStr : String!
    var Comment: String!
    var RequestedDate: String!
    var ClosedDate: String!
    var TypeStr: String!
    var type: Int!
    var isActiveRequest = false
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!) {
        if json.isEmpty{
            return
        }
        RequestOngoing = json["RequestOngoing"].boolValue
        iD = json["ID"].stringValue
        State = json["State"].intValue
        StateStr = json["StateStr"].stringValue
        Comment = json["Comment"].stringValue
        RequestedDate = json["RequestedDate"].stringValue
        ClosedDate = json["ClosedDate"].stringValue
        TypeStr = json["TypeStr"].stringValue
        type = json["Type"].int
    }
}
