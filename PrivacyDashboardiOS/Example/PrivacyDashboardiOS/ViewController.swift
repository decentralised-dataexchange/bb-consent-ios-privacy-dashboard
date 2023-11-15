//
//  ViewController.swift
//  PrivacyDashboardiOS
//
//  Created by Mumthasir mohammed on 08/24/2023.
//  Copyright (c) 2023 Mumthasir mohammed. All rights reserved.
//

import UIKit
import PrivacyDashboardiOS

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    // 1. For showing Privacy Dashboard
//        PrivacyDashboard.showPrivacyDashboard(withApiKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJTY29wZXMiOlsic2VydmljZSJdLCJPcmdhbmlzYXRpb25JZCI6IjY1MjY1Nzk2OTM4MGYzNWZhMWMzMDI0NSIsIk9yZ2FuaXNhdGlvbkFkbWluSWQiOiI2NTI2NTc5NjkzODBmMzVmYTFjMzAyNDMiLCJleHAiOjE3MDA3MjkxOTF9.2rkHNiLDjQi8WOy4CWn96sMBx8KkvFCUMU0Xe6oXNbY",
//                                              withUserId: "65378403b3f442eb9381b38d",
//                                              withOrgId: "64f09f778e5f3800014a879a",
//                                              withBaseUrl: "https://staging-consent-bb-api.igrant.io/v2",
//                                              turnOnAskme: false,
//                                              turnOnUserRequest: false,
//                                              turnOnAttributeDetail: false)
        
        // 2. For showing Data sharing UI
//        PrivacyDashboard.showDataSharingUI(apiKey:"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJTY29wZXMiOlsic2VydmljZSJdLCJPcmdhbmlzYXRpb25JZCI6IjY1MjY1Nzk2OTM4MGYzNWZhMWMzMDI0NSIsIk9yZ2FuaXNhdGlvbkFkbWluSWQiOiI2NTI2NTc5NjkzODBmMzVmYTFjMzAyNDMiLCJleHAiOjE3MDA3MjkxOTF9.2rkHNiLDjQi8WOy4CWn96sMBx8KkvFCUMU0Xe6oXNbY",
//                                           userId: "65378403b3f442eb9381b38d",
//                                           baseUrlString: "https://staging-consent-bb-api.igrant.io/v2",
//                                           dataAgreementId: "65522d05b792e39cff5cab2c",
//                                           organisationName: "My company",
//                                           organisationLogoImageUrl: "https://www.kasandbox.org/programming-images/avatars/old-spice-man-blue.png",
//                                           termsOfServiceText: "Terms of service.",
//                                           termsOfServiceUrl: "http://google.com",
//                                           cancelButtonText: "Cancel")
       
        
       // 3. Call back method to receive response back
        PrivacyDashboard.receiveDataBackFromPrivacyDashboard  = { data in
            debugPrint("Data receieved here:\(data)")
        }
        

        // 4. Setting API configuring params
          PrivacyDashboard.configure(withApiKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJTY29wZXMiOlsic2VydmljZSJdLCJPcmdhbmlzYXRpb25JZCI6IjY1MjY1Nzk2OTM4MGYzNWZhMWMzMDI0NSIsIk9yZ2FuaXNhdGlvbkFkbWluSWQiOiI2NTI2NTc5NjkzODBmMzVmYTFjMzAyNDMiLCJleHAiOjE3MDA3MjkxOTF9.2rkHNiLDjQi8WOy4CWn96sMBx8KkvFCUMU0Xe6oXNbY", withUserId: "65378403b3f442eb9381b38d", withOrgId: "64f09f778e5f3800014a879a", withBaseUrl: "https://staging-consent-bb-api.igrant.io/v2")
        
        
        // 5. Update Data agreement
//        PrivacyDashboard.updateDataAgreementStatus(dataAgreementId: "6551c9ba7654351e98a58734", status: true)
        
        // 6. Individual related API calls
//        PrivacyDashboard.fetchAllIndividuals { success, resultVal in
//            debugPrint(resultVal)
//        }
        
        // 7. Open Data agreement policy UI
//        PrivacyDashboard.showDataAgreementPolicy(dataAgreementRecord: dict)
        
        // 8. Read data agreement 
        PrivacyDashboard.readDataAgreementApi(dataAgreementId: "65539173ed8be121fe2a59af") { success, resultVal in
            print(resultVal)
            let dict = resultVal["dataAgreement"] as? [String: Any]
            if let theJSONData = try? JSONSerialization.data(withJSONObject: dict ?? [:], options: .prettyPrinted),
               let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
                if let json = theJSONText.data(using: String.Encoding.utf8) {
                    if let jsonData = try? JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject] {
                        PrivacyDashboard.showDataAgreementPolicy(dataAgreementDic: jsonData)
                    }
                }
            }
        }
        
        // 8. Read data agreement 
//        PrivacyDashboard.readDataAgreementApi(dataAgreementId: "65535cad70eaa866249023d4") { success, resultVal in
//            print(resultVal)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

