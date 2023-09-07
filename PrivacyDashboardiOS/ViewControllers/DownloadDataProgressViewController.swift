//
//  DownloadDataProgressViewController.swift
//  iGrant
//
//  Created by Mohamed Rebin on 12/06/19.
//  Copyright © 2019 iGrant.com. All rights reserved.
//

import UIKit
import StepProgressView

class DownloadDataProgressViewController: UIViewController {
    var requestStatus: RequestStatus?
    @IBOutlet weak var stepView: StepProgressView!
    var organisationId: String?
    var requestType: RequestType?
    @IBOutlet weak var cancelButton: UIButton!
    var fromHistory = false;
    let Steps = [
        NSLocalizedString("Request Initiated", comment: ""),
        NSLocalizedString("Request Acknowledged", comment: ""),
        NSLocalizedString("Request Processed", comment: "")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepView.steps = Steps
        stepView.verticalPadding = 60
        stepView.lastStepShape = .circle
        stepView.lineWidth = 3
        stepView.pastStepColor = .darkGray
        stepView.pastTextColor = stepView.pastStepColor
        stepView.pastStepFillColor = stepView.pastStepColor
        stepView.currentStepColor = #colorLiteral(red: 0, green: 0.3553411961, blue: 0.6003383994, alpha: 1)
        stepView.currentTextColor = stepView.currentStepColor
        stepView.currentDetailColor =  UIColor.gray
        stepView.futureStepColor = UIColor.lightGray
        stepView.currentStep = ((requestStatus?.State ?? 1) - 1)
        stepView.currentDetailColor = UIColor.black
        
        self.navigationController?.navigationBar.isHidden = false
        if self.requestType == RequestType.DownloadData || self.requestStatus?.type == 2{
            self.title = NSLocalizedString("Download Data Request Status", comment: "")
        } else {
            self.title = NSLocalizedString("Delete Data Request Status", comment: "")
        }
        let comments = [ 0 : formattedDate(dateStr: requestStatus?.RequestedDate ?? ""),
                         1 : " ",
                         2 : (stepView.currentStep > 1) ? (requestStatus?.StateStr ?? "") : ""];
        stepView.details = comments
        cancelButton.showRoundCorner()
        if fromHistory {
            cancelButton.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    

    func formattedDate(dateStr: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: dateStr.replacingOccurrences(of: " +0000 UTC", with: ""))
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        dateFormatter.timeZone = TimeZone.current
        let timeStamp = dateFormatter.string(from: date ?? Date())
        
        return timeStamp
    }
    @IBAction func cancelButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: NSLocalizedString("Cancel request", comment: ""), message: NSLocalizedString("Do you want to cancel this request?", comment: ""), preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: { action in
            self.callCancelRequestApi()
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func callCancelRequestApi(){
        // self.addLoadingIndicator()
        let serviceManager = OrganisationWebServiceManager()
        serviceManager.managerDelegate = self
        serviceManager.cancelRequest(orgId: self.organisationId ?? "", requestId: self.requestStatus?.iD ?? "", type: self.requestType ?? RequestType.DownloadData)
    }
}
extension DownloadDataProgressViewController: WebServiceTaskManagerProtocol{
    
    func didFinishTask(from manager:AnyObject, response:(data:RestResponse?,error:String?)){
        // self.removeLoadingIndicator()
        
        if response.error != nil{
            self.showErrorAlert(message: (response.error)!)
            return
        }
        
        if let serviceManager = manager as? OrganisationWebServiceManager{
            if serviceManager.serviceType == .cancelRequest{
                let alert = UIAlertController(title: NSLocalizedString("Cancel request", comment: ""), message: NSLocalizedString("Your request cancelled successfully", comment: ""), preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        
    }
    
}
