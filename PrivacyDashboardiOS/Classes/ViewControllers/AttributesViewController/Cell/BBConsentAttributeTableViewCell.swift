
//
//  BBConsentAttributeTableViewCell.swift
//  PrivacyDashboardiOS

//  Created by Mumthasir mohammed on 11/09/23.
//

import UIKit

class BBConsentAttributeTableViewCell: UITableViewCell {
    @IBOutlet weak var rightArrow: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var consentTypeLbl: UILabel!
    var consentInfo : ConsentDetails?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func showData() {
        self.titleLbl.text = self.consentInfo?.descriptionField
        self.dataLbl.text = self.consentInfo?.value
        if self.consentInfo?.status.consented == .Allow {
            self.consentTypeLbl.text = NSLocalizedString(Constant.Strings.allow, comment: "")
        }
        else if self.consentInfo?.status.consented == .AskMe {
            self.consentTypeLbl.text = NSLocalizedString(Constant.Strings.askMe, comment: "")
        }
        else{
            self.consentTypeLbl.text = NSLocalizedString(Constant.Strings.disallow, comment: "")
        }
    }
}
