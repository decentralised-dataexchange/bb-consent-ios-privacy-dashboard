
//
//  HistoryListTableViewCell.swift
//  iGrant
//
//  Created by Ajeesh T S on 21/10/18.
//  Copyright © 2018 iGrant.com. All rights reserved.
//

import UIKit
import AFDateHelper

class HistoryListTableViewCell: UITableViewCell {
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    var history : ConsentHistory?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func showData(){
        if let dateval = history?.timeStamp{
            
           // timeLbl.text = Utilitymethods.relationalDateToString(dateString: dateval)
            let date = dateval.dateFromISO8601
            //            let date = Date(timeInterval: dateStr, since:.isoDateTimeMilliSec)
            //                .custom("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"))
            let day = date?.component(.day)

            let month = date?.toString(style: .shortMonth)
            var monthVal : String!
            if month != nil{
                monthVal  = month!
            }
            timeLbl.text = monthVal
            if day != nil{
                let dayVal  : Int = day!
                timeLbl.text = monthVal + " \(dayVal)"
            }
            let isToday = date?.compare(.isToday)
            if isToday == true{
                let today = Date()
                let secondsSince = date?.since(today, in: .hour)
                if secondsSince != nil{
                    let hourVal : Int = Int(abs(secondsSince!))
                    timeLbl.text = "\(String(describing: hourVal))h"
                    if hourVal < 1{
                        let minuteInfo = date?.since(today, in: .minute)
                        if minuteInfo != nil{
                            let minuteVal : Int = Int(abs(minuteInfo!))
                            timeLbl.text = "\(String(describing: minuteVal))m"
                            if minuteVal < 1{
                                let secondInfo = date?.since(today, in: .second)
                                if secondInfo != nil{
                                    let scondVal : Int = Int(abs(secondInfo!))
                                    timeLbl.text = "\(String(describing: scondVal))s"
                                }
                            }
                        }
                    }

                }
            } else{
                //timeLbl.text = date?.toString()
                timeLbl.text = BBConsentUtilityMethods.relationalDateToString(dateString: dateval)
            }
        }
        
        contentLbl.text = history?.log
    }
    
    
}

