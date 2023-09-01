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
        let bundle = Bundle(for: vc.self)
        guard let resourcesBundleUrl = bundle.resourceURL?.appendingPathComponent("Main.bundle") else {
            return UIStoryboard(name:"Main", bundle: Bundle.init(for: vc))
        }
        return UIStoryboard(name:"Main", bundle: Bundle(url: resourcesBundleUrl))
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
        static let KAppName = "PrivacyDashboardiOS"
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
    }

    struct CustomTabelCell{
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
    }
}
