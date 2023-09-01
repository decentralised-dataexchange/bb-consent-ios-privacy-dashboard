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
        // Invoking 'BBConsentPrivacyDashboardiOS' SDK
        BBConsentPrivacyDashboardiOS.shared.log()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

