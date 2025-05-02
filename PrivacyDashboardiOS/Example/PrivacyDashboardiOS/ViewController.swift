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
//                PrivacyDashboard.showPrivacyDashboard(withApiKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJTY29wZXMiOlsiY29uZmlnIiwiYXVkaXQiLCJzZXJ2aWNlIiwib25ib2FyZCJdLCJPcmdhbmlzYXRpb25JZCI6IjYzOGRkM2IxMmY1ZDE3MDAwMTQ0MzFlYyIsIk9yZ2FuaXNhdGlvbkFkbWluSWQiOiI2MzhkZDM3ODJmNWQxNzAwMDE0NDMxZWIiLCJEYXRhVmVyaWZpZXJVc2VySWQiOiIiLCJFbnYiOiIiLCJleHAiOjE3NDk2NTA4NzZ9.a2nXRztms8PrE4i3cjElTpn9ktQVmyVd1-NGNoFJ7QU",
//                                                      withUserId: "6606870683175119a9ab6740",
//                                                      withOrgId: "638dd3b12f5d1700014431ec",
//                                                      withBaseUrl: "https://staging-api.igrant.io/v2",
//                                                      turnOnAskme: false,
//                                                      turnOnUserRequest: false,
//                                                      turnOnAttributeDetail: false,
//                                                      onConsentChange: { success, resultVal, consentRecordID  in
//                                                            debugPrint("Consent change here:\(success) - \(resultVal) \(consentRecordID)")
//                                                },
//                                                      viewMode: .bottomSheet)
        
        // 2. For showing Data sharing UI
        //      PrivacyDashboard.showDataSharingUI(apiKey: <API Key >,
        //                                           userId: <User ID>,
        //                                           baseUrlString: <Base Url>,
        //                                           dataAgreementId: <Data agreement ID>,
        //                                           organisationName: "My company",
        //                                           organisationLogoImageUrl: <Logo image Url>,
        //                                           termsOfServiceText: "Terms of service.",
        //                                           termsOfServiceUrl: <Terms of service Url>,
        //                                           cancelButtonText: "Cancel")
       
        
        // 3. Call back method to receive response back
        //        PrivacyDashboard.receiveDataBackFromPrivacyDashboard  = { data in
        //            debugPrint("Data receieved here:\(data)")
        //        }
        

        // 4. Setting API configuring params
                PrivacyDashboard.configure(withApiKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJTY29wZXMiOlsiY29uZmlnIiwiYXVkaXQiLCJzZXJ2aWNlIiwib25ib2FyZCJdLCJPcmdhbmlzYXRpb25JZCI6IjYzOGRkM2IxMmY1ZDE3MDAwMTQ0MzFlYyIsIk9yZ2FuaXNhdGlvbkFkbWluSWQiOiI2MzhkZDM3ODJmNWQxNzAwMDE0NDMxZWIiLCJEYXRhVmVyaWZpZXJVc2VySWQiOiIiLCJFbnYiOiIiLCJleHAiOjE3NDk2NTA4NzZ9.a2nXRztms8PrE4i3cjElTpn9ktQVmyVd1-NGNoFJ7QU",
                                           withUserId: "6606870683175119a9ab6740",
                                           withOrgId: "638dd3b12f5d1700014431ec",
                                           withBaseUrl: "https://staging-api.igrant.io/v2", withLocale: "en")
        
        
        // 5. Update Data agreement
        //        PrivacyDashboard.updateDataAgreementStatus(dataAgreementId: <Data agreement ID>,
        //                                                              status: true)
        
        // 6. Individual related API calls
        //        PrivacyDashboard.fetchAllIndividuals { success, resultVal in
        //            debugPrint(resultVal)
        //        }
        
        // 7. Open Data agreement policy UI
        
        // 8. Read data agreement
                PrivacyDashboard.readDataAgreementApi(dataAgreementId: "67e3e477cbbc346291d949aa") { success, resultVal in
                    print(resultVal)
                    PrivacyDashboard.showDataAgreementPolicy(dataAgreementDic: resultVal["dataAgreement"] as! [String : Any], viewMode: .bottomSheet)
                }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
