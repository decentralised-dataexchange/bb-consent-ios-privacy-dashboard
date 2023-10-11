# PrivacyDashboardiOS

[![CI Status](https://img.shields.io/travis/Mumthasir mohammed/PrivacyDashboardiOS.svg?style=flat)](https://travis-ci.org/Mumthasir mohammed/PrivacyDashboardiOS)
[![Version](https://img.shields.io/cocoapods/v/PrivacyDashboardiOS.svg?style=flat)](https://cocoapods.org/pods/PrivacyDashboardiOS)
[![License](https://img.shields.io/cocoapods/l/PrivacyDashboardiOS.svg?style=flat)](https://cocoapods.org/pods/PrivacyDashboardiOS)
[![Platform](https://img.shields.io/cocoapods/p/PrivacyDashboardiOS.svg?style=flat)](https://cocoapods.org/pods/PrivacyDashboardiOS)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

Environment iOS 13.0+

## Installation

PrivacyDashboardiOS is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
  pod 'PrivacyDashboardiOS'
```

## Usage

You can easily present the PrivacyDashboardHomeVC by the code shown below:
Paste the below code in ViewDidAppear method.

```#import PrivacyDashboardiOS
    BBConsentPrivacyDashboardiOS.shared.show(organisationId: "64f09f778e5f3800014a879a", apiKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOiI2NGYwYTYxZThlNWYzODAwMDE0YTg3YTYiLCJvcmdpZCI6IiIsImVudiI6IiIsImV4cCI6MTcyNDU5Njk2MX0.M3I6hJWtOyqbZXQwEGCK43AvROaoR_zncItmULpbFYE", userId: "64f0a61e8e5f3800014a87a6")
```

To enable User requests, add the following line:

```BBConsentPrivacyDashboardiOS.shared.turnOnUserRequests = true
```

To enable Ask me section in attribute detail screen, add the following line:

```BBConsentPrivacyDashboardiOS.shared.turnOnAskMeSection = true
```

## Author

iGrant.io

## License

PrivacyDashboardiOS is available under the MIT license. See the LICENSE file for more info.
