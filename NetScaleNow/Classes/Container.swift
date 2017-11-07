//
//  Container.swift
//  NetScaleNow
//
//  Created by Jonas Stubenrauch on 16.10.17.
//

import Foundation

struct Container: Codable {
  let groupConfig: GroupConfig
  let campaigns: [Campaign]
}

struct GroupConfig: Codable {
  let id: Int
  let name: String
  let campaignListTitle: String
  let campaignListSubtitle: String
  let primaryColor: String
  let termsLink: String
  let privacyPolicyLink: String
  let copyrightText: String
  let copyrightLink: String
  let newsletterTitle: String
  let newsletterSubtitle: String
  let userAgreementText: String
  let voucherTitle: String
  let voucherNote: String
  let nextVoucherTitle: String
  let nextVoucherSubtitle: String
  let maximumReachedText: String
  let newsletterIdentifier: String
}

struct Token: Codable {
  let accessToken: String
  let refreshToken: String
  let expiration: Date
  let refreshExpiration: Date
  
  var tokenIsValid: Bool {
    return Date() < expiration
  }
  
  var refreshTokenIsValid: Bool {
    return Date() < refreshExpiration
  }
  
  private enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case refreshToken = "refresh_token"
    case expiration = "expires_in"
    case refreshExpiration = "refresh_expires_in"
  }
}
