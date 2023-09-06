//
//  PrivacyDashboardiOS.swift
//  PrivacyDashboardiOS
//
//  Created by Mumthasir mohammed on 31/08/23.
//

import Foundation

public class BBConsentPrivacyDashboardiOS: UIViewController {
    
    public static var shared = BBConsentPrivacyDashboardiOS()
    public func log() {
        debugPrint("### Log from PrivacyDashboardiOS SDK.")
    }
    
    public func show() {
        let myBundle = Bundle(for: BBConsentOrganisationViewController.self)
        let storyboard = UIStoryboard(name: "PrivacyDashboard", bundle: myBundle)
        let orgVC = storyboard.instantiateViewController(withIdentifier: "BBConsentOrganisationViewController") as? BBConsentOrganisationViewController ?? BBConsentOrganisationViewController()
        let navVC = UINavigationController.init(rootViewController: orgVC)
        navVC.modalPresentationStyle = .fullScreen
        UIApplication.topViewController()?.present(navVC, animated: true, completion: nil)
    }

}
