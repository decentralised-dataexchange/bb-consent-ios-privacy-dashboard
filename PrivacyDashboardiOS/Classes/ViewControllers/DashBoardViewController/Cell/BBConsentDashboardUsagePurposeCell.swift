
//
//  BBConsentDashboardUsagePurposeCell.swift
//  PrivacyDashboardiOS
//
//  Created by Mumthasir mohammed on 04/09/23.
//

import UIKit

protocol PurposeCellDelegate: AnyObject {
    func purposeSwitchValueChanged(status:Bool,purposeInfo:PurposeConsent?,cell:BBConsentDashboardUsagePurposeCell)
}

class BBConsentDashboardUsagePurposeCell: UITableViewCell {
    weak var delegate: PurposeCellDelegate?
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var statusSwitch: UISwitch!

    var consentInfo : PurposeConsentWrapperV2?
    var consentedCount: Int?
    var totalCount: Int?
    var swictOn: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func showData() {
        self.statusSwitch.isOn = self.swictOn ? true : false
        self.statusSwitch.isEnabled = consentInfo?.lawfulUsage ?? false ? true : false
        
        self.titleLbl.text = self.consentInfo?.name
        var valueString = "Allow "
        
        if consentedCount ?? 0 > 0 {
            valueString.append(": ")
            let consentedStr = String(consentedCount ?? 0)
            valueString.append(consentedStr)
            if let total = totalCount {
                if total > 0 {
                    let totalStr = String(total)
                    valueString.append(" of ")
                    valueString.append(totalStr)
                }
            }
            self.dataLbl.text = valueString
        } else {
            self.dataLbl.text = "Disallow"
        }
    }

    @IBAction func switchValueChanged(sender: UISwitch) {
        self.delegate?.purposeSwitchValueChanged(status: sender.isOn, purposeInfo: self.consentInfo as? PurposeConsent, cell: self)
    }
}
