
//
//  ConsentTableViewCell.swift
//  iGrant
//
//  Created by Ajeesh T S on 25/03/18.
//  Copyright © 2018 iGrant.com. All rights reserved.
//

import UIKit

class ConsentTableViewCell: UITableViewCell {
    @IBOutlet weak var rightArrow: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var consentTypeLbl: UILabel!
    var consentInfo : ConsentDetails?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func showData(){
        self.titleLbl.text = self.consentInfo?.descriptionField
        self.dataLbl.text = self.consentInfo?.value
        if self.consentInfo?.status.consented == .Allow{
            self.consentTypeLbl.text = NSLocalizedString("Allow", comment: "")
        }
        else if self.consentInfo?.status.consented == .AskMe{
            self.consentTypeLbl.text = NSLocalizedString("AskMe", comment: "")
        }
        else{
            self.consentTypeLbl.text = NSLocalizedString("Disallow", comment: "")
        }
    }
}
