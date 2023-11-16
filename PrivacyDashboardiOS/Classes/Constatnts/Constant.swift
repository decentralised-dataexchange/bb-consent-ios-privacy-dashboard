//
//  Constant.swift
//  PrivacyDashboardiOS
//
//  Created by Mumthasir mohammed on 31/08/23.
//

import Foundation
import UIKit

struct Constant {
    static func getStoryboard(vc: AnyClass) -> UIStoryboard {
        let frameworkBundle = Bundle(for: vc.self)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("PrivacyDashboardiOS.bundle") 
        
        var storyboard = UIStoryboard()
        if let resourceBundle = Bundle(url: bundleURL!) {
            storyboard = UIStoryboard(name: "PrivacyDashboard", bundle: resourceBundle)
        } else {
            let myBundle = Bundle(for: BBConsentOrganisationViewController.self)
            storyboard = UIStoryboard(name: "PrivacyDashboard", bundle: myBundle)
        }
        return storyboard
    }
    
    static func getResourcesBundle(vc: AnyClass) -> Bundle? {
       let bundle = Bundle(for: vc.self)
       guard let resourcesBundleUrl = bundle.resourceURL?.appendingPathComponent("Main") else {
           return nil
       }
       return Bundle(url: resourcesBundleUrl)
   }
    struct AppSetupConstant {
        static let KSavingUSerInfoUserDefaultKey = "UserSession"
        static let KAlertTitle = "Alert"
        static let KTokenExpired = "Invalid token, Authorization failed"
    }
    
    struct ScreenSize {
        static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    struct DeviceToken {
        static let KUserDeviceTokenKey = "UserDeviceToken"
    }
    
    struct Color {
        static let UI_COLOR_BORDER =  UIColor(red:0.70, green:0.71, blue:0.71, alpha:1.00).cgColor
        static let UI_COLOR_LOGINBTN_BORDER = UIColor(red:0.55, green:0.55, blue:0.56, alpha:1.00).cgColor
    }
    
    struct Alert {
        static let KPromptMsgEnterEmail = "Please enter Email"
        static let KPromptMsgEnterComment = "Please enter Comment"
        static let KPromptMsgEnterValidEmail = "Please enter valid email"
        static let KPromptMsgEnterAddress = "Please Enter Address"
        static let KPromptMsgEnterCity = "Please Enter City"
        static let KPromptMsgEnterCountry = "Please Enter Country"
        static let KPromptMsgEnterZipcode = "Please Enter Zipcode"
        static let KPromptMsgEnterMobileNumber = "Please Enter Mobile Number"
        static let KPromptMsgEnterValidMobileNumber = "Please Enter Valid Mobile Number"

        static let KPromptMsgEnterPassword = "Please Enter Password"
        static let KPromptMsgEnterNewPassword = "Please Enter New Password"
        static let KPromptMsgEnterOTP = "Please Enter OTP"
        static let KPromptMsgPasswordMismatch = "Password Mismatch"

        static let KPromptMsgEnterValidPassword = "Password should be atleast 6 characters"
        static let KPromptMsgEnterUserName = "Please Enter name"
        static let KPromptMsgEnterLastName = "Please Enter Last Name"
        static let KPromptMsgEnterFirstName = "Please Enter First Name"
        static let KPromptMsgEnterLandmark = "Please Enter Landmark"
        static let KPromptMsgEnterMessage = "Please enter the message"
        static let KPromptServerConectError = "Server connection error"
        static let KPromptMsgEnterStartDate = "Please select the start date."
        static let KPromptMsgEnterEndDate = "Please select the end date"
        static let KPromptMsgNotConfigured = "Not Configured"
        
        static let areYouSureYouWantToAllow = "Are you sure you want to allow?"
        static let allow = "Allow"
        static let areYouSureYouWantToDisAllow = "Are you sure you want to disallow?"
        static let disallow = "Disallow"
        static let areYouWantToDisallowAll = "Are you sure you want to disallow all ?"
        static let disallowAll = "Disallow All"
        static let invalidURL = "Invalid URL"
        
        static let cancelRequest = "Cancel request"
        static let yourRequestCancelled = "Your request cancelled successfully"
        static let OK = "OK"
        static let cancel = "Cancel"
        static let doYouWantToCancelThisRequest = "Do you want to cancel this request?"
    }

    struct CustomTabelCell {
        static let KMoreCellID = "moreCell"
        static let KProfileListCellID = "ListCell"
        static let KEventCellID = "EventCell"
        static let KProfileCellID = "UserProfileCell"
        static let KSubcribedHeaderCellID = "SubcribedHeaderCell"
        static let KAddOrgBtnCellID = "AddOrgBtnCell"
        static let KRecenlyAddOrgBtnCellID = "RecentlyAddedHeaderCell"
        static let KRecenlyAddOrgCellID = "RecentlyAddedOrgCell"
        static let KOrgTypeCellID = "OrganisationTypeTableViewCell"
        static let KOrgDetailedImageCellID = "ImageCell"
        static let KOrgDetailedOverViewCellID = "OverViewCell"
        static let KOrgDetailedConsentCellID = "ConsentCell"
        static let KOrgDetailedConsentHeaderCellID = "HeaderCell"
        static let KOrgDetailedConsentAllowCellID = "AllowCell"
        static let KOrgDetailedConsentDisAllowCellID = "DisallowCell"
        static let KOrgDetailedConsentAskMeCellID = "AskMeCell"
        static let KOrgSuggestionCellID = "SuggestionCell"
        static let KRequestedStatusCellID = "RequestStatusTableViewCell"
        static let purposeCell = "PurposeCell"
        static let consentHeaderTableViewCell = "ConsentHeaderTableViewCell"
        static let consentCell = "ConsentCell"
    }
    
    struct ViewControllerID {
        static let requestStatusHistoryVC = "RequestStatusHistoryViewController"
        static let consentHistoryVC = "ConsentHistoryVC"
        static let consentListVC = "ConsentListVC"
        static let downloadDataProgressVC = "DownloadDataProgressViewController"
        static let consentVC = "ConsentVC"
        static let webViewVC = "WebViewVC"
    }
    
    struct Images {
        static let defaultCoverImage = "default_cover_image"
        static let iGrantTick = "ic_igrant_tick"
    }
    
    struct Strings {
        static let days = "Days"
        static let consent = "CONSENT"
        static let consentAllowedNoteOne = "If you choose “Allow”, you are consenting to the use of your personal data "
        static let consentAllowedNoteTwo = " permanently for any analytics or third party usage beyond the purposes you have signed up with."
        static let consentDisAllowedNote = "If you choose “Disallow”, you are disabling the use of your personal data for any analytics or third party usage beyond the purposes you have signed up with."
        static let consentDefaultNote = "If you choose “Ask me”, you consent to use your data for the selected period. When the  time period expires, you get notified in real time requesting for consent when the data provider is using your data."
        static let cancel = "Cancel"
        static let privacyPolicy = "Privacy Policy"
        static let policy = "Policy"
        static let userRequests = "User Requests"
        static let consentHistory = "Consent History"
        static let allow = "Allow"
        static let disallow = "Disallow"
        static let askMe = "AskMe"
        static let noHistoryAbailable = "No history available"
        static let downloadData = "Download Data"
        static let deleteData = "Delete Data"
        static let requestInitiated = "Request Initiated"
        static let requestAcknowledged = "Request Acknowledged"
        static let requestProcessed = "Request Processed"
        static let downloadDataRequestStatus = "Download Data Request Status"
        static let deleteDataRequestStatus = "Delete Data Request Status"
        static let dataAgreements = "DATA AGREEMENTS"
        static let dataAttributes = "DATA ATTRIBUTES"
    }
    
    struct URLStrings {
        static let createIndividual = BBConsentPrivacyDashboardiOS.shared.baseUrl + "/service/individual"
        static let readIndividual = BBConsentPrivacyDashboardiOS.shared.baseUrl + "/service/individual/"
        static let updateIndividual = BBConsentPrivacyDashboardiOS.shared.baseUrl + "/service/individual/"
        static let fetchAllIndividuals = BBConsentPrivacyDashboardiOS.shared.baseUrl + "/service/individuals"
        static let fetchDataAgreementRecord =  BBConsentPrivacyDashboardiOS.shared.baseUrl + "/service/individual/record/data-agreement/"
        static let fetchDataAgreement = BBConsentPrivacyDashboardiOS.shared.baseUrl + "/service/data-agreement/"
    }
}
