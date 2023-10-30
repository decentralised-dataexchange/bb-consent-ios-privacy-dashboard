//
//  PrivacyDashboardiOS.swift
//  PrivacyDashboardiOS
//
//  Created by Mumthasir mohammed on 31/08/23.
//

import Foundation

public class BBConsentPrivacyDashboardiOS: UIViewController {
    
    public static var shared = BBConsentPrivacyDashboardiOS()
    public var turnOnUserRequests = false
    public var turnOnAskMeSection = false
    public var turnOnAttributeDetailScreen = false
    
    var orgId: String?
    var userId: String?
    var hideBackButton = false
    
    public func log() {
        debugPrint("### Log from PrivacyDashboardiOS SDK.")
    }
    
    public func show(organisationId: String, apiKey: String, userId: String, animate: Bool = true) {
        if #available(iOS 13.0, *) {
            let appearance = UIView.appearance()
            appearance.overrideUserInterfaceStyle = .light
        }
        
        orgId = organisationId
        self.userId = userId
        if(!apiKey.isEmpty) {
            let serviceManager = LoginServiceManager()
            serviceManager.getUserDetails()
            let data = apiKey.data(using: .utf8) ?? Data()
            _ = BBConsentKeyChainUtils.save(key: "BBConsentToken", data: data)
            
            let frameworkBundle = Bundle(for: BBConsentOrganisationViewController.self)
            let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("PrivacyDashboardiOS.bundle") 
            var storyboard = UIStoryboard()
            if let resourceBundle = Bundle(url: bundleURL!) {
                storyboard = UIStoryboard(name: "PrivacyDashboard", bundle: resourceBundle)
            } else {
                let myBundle = Bundle(for: BBConsentOrganisationViewController.self)
                storyboard = UIStoryboard(name: "PrivacyDashboard", bundle: myBundle)
            }
            
            let orgVC = storyboard.instantiateViewController(withIdentifier: "BBConsentOrganisationViewController") as? BBConsentOrganisationViewController ?? BBConsentOrganisationViewController()
            orgVC.organisationId = organisationId
            let navVC = UINavigationController.init(rootViewController: orgVC)
            navVC.modalPresentationStyle = .fullScreen
            UIApplication.topViewController()?.present(navVC, animated: animate, completion: nil)
            return
        }
        
        if userId != "" {
            let orgVC = Constant.getStoryboard(vc: self.classForCoder).instantiateViewController(withIdentifier: "BBConsentOrganisationViewController") as! BBConsentOrganisationViewController
            orgVC.organisationId = organisationId
            self.userId = userId
            let navVC = UINavigationController.init(rootViewController: orgVC)
            navVC.modalPresentationStyle = .fullScreen
            if !hideBackButton{
                showBackButton()
            }
            UIApplication.topViewController()?.present(navVC, animated: true, completion: nil)
        } else {
            let loginVC = Constant.getStoryboard(vc: self.classForCoder).instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            let loginNav = UINavigationController.init(rootViewController: loginVC)
            loginVC.orgId = organisationId
            self.userId = userId
            loginNav.modalPresentationStyle = .fullScreen
            if !hideBackButton{
                showBackButton()
            }
            UIApplication.topViewController()?.present(loginNav, animated: true, completion: nil)
        }
    }

    func showBackButton(){
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "orgback"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        self.navigationItem.setRightBarButtonItems([item1], animated: true)
    }
    
    @objc func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
}
