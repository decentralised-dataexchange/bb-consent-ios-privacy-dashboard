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
//        PrivacyDashboard.showPrivacyDashboard(withApiKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJTY29wZXMiOlsic2VydmljZSJdLCJPcmdhbmlzYXRpb25JZCI6IjY1MjY1Nzk2OTM4MGYzNWZhMWMzMDI0NSIsIk9yZ2FuaXNhdGlvbkFkbWluSWQiOiI2NTI2NTc5NjkzODBmMzVmYTFjMzAyNDMiLCJleHAiOjE3MDA3MjkxOTF9.2rkHNiLDjQi8WOy4CWn96sMBx8KkvFCUMU0Xe6oXNbY",
//                                              withUserId: "65378403b3f442eb9381b38d",
//                                              withOrgId: "64f09f778e5f3800014a879a",
//                                              withBaseUrl: "https://staging-consent-bb-api.igrant.io/v2",
//                                              turnOnAskme: false,
//                                              turnOnUserRequest: false,
//                                              turnOnAttributeDetail: false)
        
        PrivacyDashboard.showDataSharingUI(apiKey:"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJTY29wZXMiOlsic2VydmljZSJdLCJPcmdhbmlzYXRpb25JZCI6IjY1MjY1Nzk2OTM4MGYzNWZhMWMzMDI0NSIsIk9yZ2FuaXNhdGlvbkFkbWluSWQiOiI2NTI2NTc5NjkzODBmMzVmYTFjMzAyNDMiLCJleHAiOjE3MDA3MjkxOTF9.2rkHNiLDjQi8WOy4CWn96sMBx8KkvFCUMU0Xe6oXNbY",
                                           userId: "65378403b3f442eb9381b38d",
                                           baseUrlString: "https://staging-consent-bb-api.igrant.io/v2",
                                           dataAgreementId: "654cf08a9684ed907ce07c26",
                                           organisationName: "My company",
                                           organisationLogoImageUrl: "https://picsum.photos/id/1/200/300",
                                           termsOfServiceText: "Terms of service.",
                                           termsOfServiceUrl: "http://google.com",
                                           cancelButtonText: "Cancel")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

