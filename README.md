<h1 align="center">
    GovStack Consent BB Privacy Dashboard (iOS SDK)
</h1>

<p align="center">
    <a href="/../../commits/" title="Last Commit"><img src="https://img.shields.io/github/last-commit/decentralised-dataexchange/bb-consent-ios-privacy-dashboard?style=flat"></a>
    <a href="/../../issues" title="Open Issues"><img src="https://img.shields.io/github/issues/decentralised-dataexchange/bb-consent-ios-privacy-dashboard?style=flat"></a>
    <a href="./LICENSE" title="License"><img src="https://img.shields.io/badge/License-Apache%202.0-yellowgreen?style=flat"></a>
</p>

<p align="center">
  <a href="#about">About</a> •
  <a href="#release-status">Release Status</a> •
  <a href="#contributing">Contributing</a> •
  <a href="#licensing">Licensing</a>
</p>

## About

This repository hosts source code for the reference implementation of the GovStack Consent Building Block Privacy Dashboard towards individuals.

## Release Status

Released. Refer to the [wiki page](https://github.com/decentralised-dataexchange/bb-consent-docs/wiki/wps-and-deliverables) for the latest status of the deliverables. 

## 1. Installation
[PrivacyDashboardiOS](https://cocoapods.org/pods/PrivacyDashboardiOS#about) is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile after all [pod set up](https://guides.cocoapods.org/using/getting-started.html) done:

```ruby
pod 'PrivacyDashboardiOS','2023.11.10'
```
## 2. Integration

Import PrivacyDashboard SDK

```
#import PrivacyDashboardiOS
```
#### Privacy Dashboard

Initiate the privacy dashboard with the code block below:

```
PrivacyDashboard.showPrivacyDashboard(withApiKey: <apiKey>,
                                      withUserId: <userId>,
                                      withOrgId:  <orgId>,
                                      withBaseUrl: <baseUrl>,
                                      turnOnAskme: <Bool>,
                                      turnOnUserRequest: <Bool>,
                                      turnOnAttributeDetail: <Bool>)
```
## Supported Functions

We can show the privacy dashboard with `accessToken` (optional parameter).

> **_Note:_** If we have `accessToken` then no need to pass `API key` and `User ID`

To set app language, pass language code to `withLocale`. 
Now supporting three languages ie: English, Swedish and Finnish (By default it'll be English) 
```
.withLocale: "en",
```

To enable user requests, set the `turnOnUserRequest` to `true`
```
.turnOnUserRequest : true
```
To enable Ask me, set the `turnOnAskme` to `true`
```
 .turnOnAskme : true
```
To enable Attribute detail screen, set the `turnOnAttributeDetail` to `true`
```
 .turnOnAttributeDetail : true
```
#### Data Sharing UI
To initiate the Data sharing UI
```
PrivacyDashboard.showDataSharingUI(apiKey: <API key>,
            userId: <API key>,
            baseUrlString: <>,
            dataAgreementId: <Data Agreement ID>,
            organisationName: <Third party application name>,
            organisationLogoImageUrl: <Third party application logo>,
            termsOfServiceText:<Terms of service text>,     
            termsOfServiceUrl: <Terms url>,
            cancelButtonText: <Cancel button text>)
```
We can also show the privacy dashboard with `accessToken` with below param
```
.accessToken(<accessToken>)
```
> **_Note:_** If we have `accessToken` then no need to pass `API key` and `User ID`

In response, it will return a json string as follows. `Null` if the process failed
```
    {
        "id": "********************",
        "dataAgreementId": "********************",
        "dataAgreementRevisionId": "********************",
        "dataAgreementRevisionHash": "*******************************",
        "individualId": "********************",
        "optIn": Boolean,
        "state": "*********",
        "signatureId": ""
    }
```
#### Configuring API key or Access token 
Below 'configure' method should be called before api calls which doesnt have API key or access token as params. 
```
         PrivacyDashboard.configure(withApiKey: <APIKey>, 
                                    withOrgId: <OrgId>, 
                                    withBaseUrl: <BaseUrl>,
                                    accessToken: <accessToken>)
```
#### Opt-in to Data Agreement
This function is used to provide the 3PP developer to opt-in to a data agreement. 
```
        PrivacyDashboard.updateDataAgreementStatus(dataAgreementId: <Data Agreement ID>, 
                                                   status: <True always>)
```

In response, it will return a json string as follows. `Null` if the process failed
```
    {
        "id": "********************",
        "dataAgreementId": "********************",
        "dataAgreementRevisionId": "********************",
        "dataAgreementRevisionHash": "*******************************",
        "individualId": "********************",
        "optIn": Boolean,
        "state": "*********",
        "signatureId": ""
    }
```
#### Fetch Data Agreement
This function is used to fetch the data agreement using `dataAgreementId`
```
    PrivacyDashboard.readDataAgreementApi(dataAgreementId: <>)  { 
     success, resultVal in
    // Result val will be a callback 
    // response in dictionary format
    }
```
#### Show data agreement policy
To show data agreement policy, fetch the data agreement with the above API, pass the response with below api request
```
        PrivacyDashboard.showDataAgreementPolicy(dataAgreementRecord:
        <Data agreement response>)
```

#### Individual Functions
##### To Create an Individual
  To create individual below one is the API request
```
    PrivacyDashboard.createAnIndividual(
                            name: <Optional>, 
                            email: <Optional>, 
                            phone: <Optional>) 
                            { success, resultVal in
                              // Result val will be a callback 
                              // response in dictionary format
                             }
```
##### To fetch an Individual
  To fetch indivdual details
```
   PrivacyDashboard.readAnIndividual(
                            individualId = <individual ID>
                            { success, resultVal in
                              // Result val will be a callback 
                              // response in dictionary format
                             }
 ```                            
##### To update an Individual
To update individual record
```
   PrivacyDashboard.updateAnIndividual(
                            individualId = <individual ID>
                            { success, resultVal in
                              // Result val will be a callback 
                              // response in dictionary format
                             }
 ```  
 ##### To fetch all individuals
 To fetch all individual records
 ```
   PrivacyDashboard.fetchAllIndividuals(
                            individualId = <individual ID>
                            { success, resultVal in
                              // Result val will be a callback 
                              // response in dictionary format
                             }
 ```  
 
## Other resources

* Wiki - https://github.com/decentralised-dataexchange/consent-dev-docs/wiki

## Contributing

Feel free to improve the plugin and send us a pull request. If you find any problems, please create an issue in this repo.

## Licensing
Copyright (c) 2023-25 LCubed AB (iGrant.io), Sweden

Licensed under the Apache 2.0 License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the LICENSE for the specific language governing permissions and limitations under the License.
