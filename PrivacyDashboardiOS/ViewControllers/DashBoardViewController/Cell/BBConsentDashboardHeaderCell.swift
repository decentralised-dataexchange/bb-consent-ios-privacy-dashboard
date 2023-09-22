//
//  BBConsentDashboardHeaderCell.swift
//  PrivacyDashboardiOS
//
//  Created by Mumthasir mohammed on 04/09/23.
//


import UIKit
import Kingfisher

class BBConsentDashboardHeaderCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var orgImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logoBgBtn: UIButton!
    @IBOutlet weak var gradiantView: UIView!
    @IBOutlet weak var gradiantViewTop: UIView!
    
    var orgData : Organization?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        logoImageView.layer.cornerRadius =  logoImageView.frame.size.height/2
        logoBgBtn.layer.cornerRadius =  logoBgBtn.frame.size.height/2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func showData() {
        self.nameLbl.text = self.orgData?.name
        self.locationLbl.text = self.orgData?.location
        let modifier = AnyModifier { request in
            var r = request
            r.setValue("Bearer \(UserInfo.currentUser()?.token ?? "")", forHTTPHeaderField: "Authorization")
            if let tokendata = BBConsentKeyChainUtils.load(key: "BBConsentToken") {
                let token = String(data: tokendata, encoding: .utf8) ?? ""
                r.setValue("ApiKey \(token)", forHTTPHeaderField: "Authorization")
            }
            return r
        }
        
//        self.orgImageView.image = UIImage(named: Constant.Images.defaultCoverImage)
//        if let imageUrl = self.orgData?.coverImageURL{
//            let placeholder = UIImage(named: Constant.Images.defaultCoverImage, in: Constant.getResourcesBundle(vc: BBConsentBaseViewController().classForCoder), compatibleWith: nil)
//            self.orgImageView.kf.setImage(with: imageUrl, placeholder: placeholder, options: [.requestModifier(modifier)])
//        }
//        
//        self.logoImageView.image = UIImage(named: Constant.Images.iGrantTick)
//        if let imageUrl = self.orgData?.logoImageURL{
//            let placeholder = UIImage(named: Constant.Images.iGrantTick, in: Constant.getResourcesBundle(vc: BBConsentBaseViewController().classForCoder), compatibleWith: nil)
//            self.logoImageView.kf.setImage(with: imageUrl, placeholder: placeholder, options: [.requestModifier(modifier)])
//        }
    }
}
