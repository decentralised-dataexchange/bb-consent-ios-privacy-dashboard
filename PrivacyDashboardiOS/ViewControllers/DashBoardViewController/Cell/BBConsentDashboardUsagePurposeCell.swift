
//
//  BBConsentDashboardUsagePurposeCell.swift
//  PrivacyDashboardiOS
//
//  Created by Mumthasir mohammed on 04/09/23.
//

import UIKit

protocol PurposeCellDelegate: class {
    func purposeSwitchValueChanged(status:Bool,purposeInfo:PurposeConsent?,cell:BBConsentDashboardUsagePurposeCell)
}

class BBConsentDashboardUsagePurposeCell: UITableViewCell {
    weak var delegate: PurposeCellDelegate?
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var statusSwitch: UISwitch!

    var consentInfo : PurposeConsent?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func showData() {
        if self.consentInfo?.purpose.lawfulUsage == true {
            self.statusSwitch.isOn = true
            self.statusSwitch.isEnabled = false
        } else {
            self.statusSwitch.isEnabled = true
        }
        self.titleLbl.text = self.consentInfo?.purpose.name
        if let consented = self.consentInfo?.count.consented {
            var valueString = "Allow "
            
            if consented > 0 {
                self.statusSwitch.isOn = true
                valueString.append(": ")
                let consentedStr = String(consented)
                valueString.append(consentedStr)
                if let total = self.consentInfo?.count.total {
                    if total > 0 {
                        let totalStr = String(total)
                        valueString.append(" of ")
                        valueString.append(totalStr)
                    }
                }
                self.dataLbl.text = valueString
            } else {
                self.statusSwitch.isOn = false
                self.dataLbl.text = "Disallow"
            }
        }
    }

    @IBAction func switchValueChanged(sender: UISwitch) {
        self.delegate?.purposeSwitchValueChanged(status: sender.isOn, purposeInfo: self.consentInfo, cell: self)
    }
}
