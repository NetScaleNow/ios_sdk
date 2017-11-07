//
//  Campaign.swift
//  Pods
//
//  Created by Jonas Stubenrauch on 05.05.17.
//
//

import Foundation

struct Campaign :Codable {
  var id: Int
  var name: String
  var discount: String
  var desc: String?
  
  var limitations: String?
  var logoUrl: String?
  var headerUrl: String?
  var shopLink: String?
  var limitationsDescription: String?
    var resizedLogoUrl: String? {
        guard let logoUrl = logoUrl else {
            return nil
        }
        return "http://my.netscalenow.de/r/thumbnail?url=\(logoUrl)&height=\((60 * UIScreen.main.scale))"
    }
    var resizedHeaderUrl: String? {
        guard let headerUrl = headerUrl else {
            return nil
        }
        
        let size = 304 * UIScreen.main.scale
        return "http://my.netscalenow.de/r/resize?url=\(headerUrl)&width=\(size)&height=\(size)"
    }
  
  private enum CodingKeys: String, CodingKey {
    case id
    case name
    case discount = "value"
    case logoUrl = "advertiserLogoUrl"
    case headerUrl = "campaignImageUrl"
    case limitations
    case limitationsDescription
    case desc = "description"
    case shopLink
  }
}

extension Campaign: Equatable {
  static func ==(lhs: Campaign, rhs: Campaign) -> Bool {
    return lhs.id == rhs.id
  }
}

