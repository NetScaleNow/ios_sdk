//
//  Voucher.swift
//  Pods
//
//  Created by Jonas Stubenrauch on 23.05.17.
//
//

import Foundation

struct Voucher: Codable {
  var code: String
  var subscribedToNewsletter = false
  var campaign: Campaign? = nil
  
  private enum CodingKeys: String, CodingKey {
    case code
    case subscribedToNewsletter = "hasSubscribedToNewsletter"
   }
    
}
