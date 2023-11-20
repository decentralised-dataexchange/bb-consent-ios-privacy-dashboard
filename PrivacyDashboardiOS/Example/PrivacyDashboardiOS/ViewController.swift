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
        //        PrivacyDashboard.showPrivacyDashboard(withApiKey: <API Key>,
        //                                              withUserId: <User ID>,
        //                                              withOrgId: <Organisation ID>,
        //                                              withBaseUrl: <Base Url>,
        //                                              withLocale: "en",
        //                                              turnOnAskme: false,
        //                                              turnOnUserRequest: false,
        //                                              turnOnAttributeDetail: false)
        
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
        //        PrivacyDashboard.configure(withApiKey: <API Key >,
        //                                               withUserId: <User ID>,
        //                                                withOrgId: <Organisation ID>,
        //                                              withBaseUrl: <Base Url>)
        
        
        // 5. Update Data agreement
        //        PrivacyDashboard.updateDataAgreementStatus(dataAgreementId: <Data agreement ID>,
        //                                                              status: true)
        
        // 6. Individual related API calls
        //        PrivacyDashboard.fetchAllIndividuals { success, resultVal in
        //            debugPrint(resultVal)
        //        }
        
        // 7. Open Data agreement policy UI
        //        PrivacyDashboard.showDataAgreementPolicy(dataAgreementRecord: <JSON data of "dataAgreement" response>)
        
        // 8. Read data agreement 
        //        PrivacyDashboard.readDataAgreementApi(dataAgreementId: <Organisation ID>) { success, resultVal in
        //            print(resultVal)
        //        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

