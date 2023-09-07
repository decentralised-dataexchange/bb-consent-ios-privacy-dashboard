
//
//  BBConsentDashBoardOverviewCell.swift
//  PrivacyDashboardiOS
//
//  Created by Mumthasir mohammed on 04/09/23.
//

import UIKit
import ExpandableLabel

class BBConsentDashBoardOverviewCell: UITableViewCell {
    @IBOutlet weak var overViewLbl: ExpandableLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "Read More")
        let colorRange = NSMakeRange(0,"Read More".count)
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red:0.59, green:0.59, blue:0.61, alpha:1), range:colorRange)
        overViewLbl.collapsedAttributedLink = attributeString
        
        let readLessattributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "Read Less")
        let colorRangeReadLess = NSMakeRange(0,"Read Less".count)
        readLessattributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red:1, green:0.53, blue:0.54, alpha:1), range:colorRangeReadLess)
        overViewLbl.expandedAttributedLink = readLessattributeString
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
