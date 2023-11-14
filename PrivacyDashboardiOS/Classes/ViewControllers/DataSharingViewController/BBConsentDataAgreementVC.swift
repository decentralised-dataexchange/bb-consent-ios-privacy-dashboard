//
//  BBConsentDataAgreementVC.swift
//  PrivacyDashboardiOS
//
//  Created by Mumthasir mohammed on 10/11/23.
//

import Foundation

// MARK: Custom cell
class DACell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
}

class BBConsentDataAgreementVC: UITableViewController {
    var dataAgreement: [PurposeConsentWrapperV2]?
    var purposeSectionDic = [String:Any]()
    var policySectionDict = [String:Any]()
    var DPIASectionDic = [String:Any]()
    var dataAgreementDic = [[String: Any]]()
    
    override func viewDidLoad() {
        setUI()
        setData()
    }
    
    func setUI() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DAcell")
        self.navigationItem.title = "Data Agreement"
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .black
    }
    
    func setData() {
        if dataAgreementDic.count < 1 {
            purposeSectionDic = ["Purpose": dataAgreement?[0].name ?? "", "Purpose Description": dataAgreement?[0].descriptionField ?? "", "Lawful basis of processing": dataAgreement?[0].lawfulBasis ?? ""]
            policySectionDict = ["Policy URL": dataAgreement?[0].policyURL ?? "", "Jurisdiction": dataAgreement?[0].jurisdiction ?? "", "Third party data sharing": dataAgreement?[0].thirdPartyDisclosure ?? "", "Industry scope": dataAgreement?[0].industryScope ?? "", "Geographic restriction": dataAgreement?[0].geaographicRestriction ?? "", "Retention period": dataAgreement?[0].retentionPeriod ?? "", "Storage Location": dataAgreement?[0].storageLocation ?? ""]
            DPIASectionDic = ["DPIA Date": dataAgreement?[0].DPIAdate ?? "", "DPIA Summary": dataAgreement?[0].DPIASummary ?? ""]
            dataAgreementDic = [purposeSectionDic, policySectionDict, DPIASectionDic]
        }
    }
    
    // MARK: TableView delegates & datasources
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        dataAgreementDic.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataAgreementDic[section].count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cornerRadius : CGFloat = 10.0
        cell.backgroundColor = UIColor.clear
        let layer: CAShapeLayer = CAShapeLayer()
        let pathRef:CGMutablePath = CGMutablePath()
        let bounds: CGRect = cell.bounds.insetBy(dx:0,dy:0)
        var addLine: Bool = false
        
        if (indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1) {
            pathRef.addRoundedRect(in: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        } else if (indexPath.row == 0) {
            pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.minY), tangent2End: CGPoint(x: bounds.midX, y: bounds.midY), radius: cornerRadius)
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.minY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
            pathRef.addLine(to:CGPoint(x: bounds.maxX, y: bounds.maxY) )
            addLine = true
        } else if (indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1) {
            pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.minY), transform: CGAffineTransform())
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY), radius: cornerRadius)
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
            pathRef.addLine(to:CGPoint(x: bounds.maxX, y: bounds.minY) )
        } else {
            pathRef.addRect(bounds)
            addLine = true
        }
        
        layer.path = pathRef
        layer.fillColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.5).cgColor
        
        if (addLine == true) {
            let lineLayer: CALayer = CALayer()
            let lineHeight: CGFloat = (1.0 / UIScreen.main.scale)
            lineLayer.frame = CGRect(x:bounds.minX + 10 , y:bounds.size.height-lineHeight, width:bounds.size.width-10, height:lineHeight)
            lineLayer.backgroundColor = tableView.separatorColor?.cgColor
            layer.addSublayer(lineLayer)
        }
        let testView: UIView = UIView(frame: bounds)
        testView.layer.insertSublayer(layer, at: 0)
        testView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        cell.backgroundView = testView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DACell", for: indexPath) as! DACell
        let item = dataAgreementDic[indexPath.section]
        let keys = item.map({ $0.key })
        let values = item.map({ $0.value })
        cell.titleLabel.text = keys[indexPath.row]
        cell.descLabel.text = values[indexPath.row] as? String
        return cell
    }
}
