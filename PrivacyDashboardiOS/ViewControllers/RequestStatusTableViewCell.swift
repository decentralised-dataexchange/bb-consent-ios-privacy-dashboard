//
//  RequestStatusTableViewCell.swift
//  iGrant
//
//  Created by Mohamed Rebin on 06/07/19.
//  Copyright © 2019 iGrant.com. All rights reserved.
//

import UIKit

class RequestStatusTableViewCell: UITableViewCell {
    @IBOutlet weak var statusType: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var statusDetail: UILabel!
    @IBOutlet weak var cancelButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func showDate(dateval: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: dateval.replacingOccurrences(of: " +0000 UTC", with: ""))
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        dateFormatter.timeZone = TimeZone.current
        let timeStamp = dateFormatter.string(from: date!)
        
        self.date.text = timeStamp
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
