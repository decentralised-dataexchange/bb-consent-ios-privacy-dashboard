
//
//  AskMeSliderTableViewCell.swift
//  iGrant
//
//  Created by Ajeesh T S on 26/03/18.
//  Copyright © 2018 iGrant.com. All rights reserved.
//

import UIKit

protocol AskMeSliderCellDelegate: class {
    func askMeSliderValueChanged(days:Int)
    func updatedSliderValue(days:Int,indexPath:IndexPath)

}

class AskMeSliderTableViewCell: UITableViewCell {
    weak var delegate: AskMeSliderCellDelegate?

    @IBOutlet weak var selectedDaysLbl: UILabel!
    @IBOutlet weak var tickImage: UIImageView!
    @IBOutlet weak var askMeSlider: UISlider!
    var consent :Consent?
    var index : IndexPath!
    var slidercurrentValue = 30

    override func awakeFromNib() {
        super.awakeFromNib()
//        askMeSlider.isContinuous = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        
        slidercurrentValue = Int(sender.value)
        selectedDaysLbl.text = "\(slidercurrentValue) Days"
        self.delegate?.askMeSliderValueChanged(days: slidercurrentValue)
//        tickImage.isHidden = false
    }
    
    @IBAction func sliderDidEndSliding() {
        print("end sliding")
        self.delegate?.updatedSliderValue(days: slidercurrentValue, indexPath: index)
    }

}
