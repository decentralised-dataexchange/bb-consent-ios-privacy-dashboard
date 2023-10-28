//
//  DataAgreementRecords.swift
//  PrivacyDashboardiOS
//
//  Created by Mumthasir mohammed on 26/10/23.
//

import Foundation

// MARK: - DataAgreementRecords
struct DataAgreementRecords: Codable {
    var  dataAgreementRecords: [DataAgreementRecord]?
    var pagination: Pagination?
}

// MARK: - DataAgreementRecord
class DataAgreementRecord: Codable {
    var id: String?
    var dataAgreementId: String?
    var dataAgreementRevisionId: String?
    var dataAgreementRevisionHash: String?
    var dataAttributes: [DataAttributeDetails]?
    var individualID: String?
    var optIn: Bool?
    var state, signatureId: String?
}

// MARK: - DataAttribute
class DataAttributeDetails: Codable {
    var id: String?
    var dataAttributeRevisionId: String?
    var dataAttributeRevisionHash: String?
    var optIn: Bool?
}
