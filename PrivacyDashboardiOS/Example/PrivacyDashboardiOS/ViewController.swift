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
        // Invoking 'BBConsentPrivacyDashboardiOS' SDK
        BBConsentPrivacyDashboardiOS.shared.show(organisationId: "64f09f778e5f3800014a879a", apiKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJTY29wZXMiOlsic2VydmljZSJdLCJPcmdhbmlzYXRpb25JZCI6IjY1MjY1Nzk2OTM4MGYzNWZhMWMzMDI0NSIsIk9yZ2FuaXNhdGlvbkFkbWluSWQiOiI2NTI2NTc5NjkzODBmMzVmYTFjMzAyNDMiLCJleHAiOjE3MDA3MjkxOTF9.2rkHNiLDjQi8WOy4CWn96sMBx8KkvFCUMU0Xe6oXNbY", userId: "65378403b3f442eb9381b38d")
        //  BBConsentPrivacyDashboardiOS.shared.show(organisationId: "64f09f778e5f3800014a879a", apiKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOiI2NGYwYTYxZThlNWYzODAwMDE0YTg3YTYiLCJvcmdpZCI6IiIsImVudiI6IiIsImV4cCI6MTcyNDU5Njk2MX0.M3I6hJWtOyqbZXQwEGCK43AvROaoR_zncItmULpbFYE", userId: "64f0a61e8e5f3800014a87a6")

        BBConsentPrivacyDashboardiOS.shared.turnOnUserRequests = true
        BBConsentPrivacyDashboardiOS.shared.turnOnAskMeSection = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

