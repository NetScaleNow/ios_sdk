//
//  Config.swift
//  Pods
//
//  Created by Jonas Stubenrauch on 05.05.17.
//
//

import Foundation


/// Used to customize the appearance of this component
public struct Config {
  
  /// The apiKey for the MobileNetwork Api.
  public static var apiKey: String?
  /// The apiSecret for the MobileNetwork Api.
  public static var apiSecret: String?
  
  /// This is the tint color of the Campaign/Voucher selection. Use this property to make the ui match your design.
  public static var primaryColor: UIColor?
  

  
  internal static var tintColor: UIColor {
    if let customColor = primaryColor {
      return customColor
    }
    
    if let groupConfig = self.groupConfig, let color = UIColor(hexString: groupConfig.primaryColor) {
      return color
    }
    
    return UIColor(red: 0.75, green: 0.62, blue: 0.35, alpha: 1)
  }
  
  internal static var bundle: Bundle {
    let frameworkBundle = Bundle(for: CampaignManager.self)
    let bundlePath = frameworkBundle.path(forResource: "NetScaleNow", ofType: "bundle")!
    return Bundle(path: bundlePath)!
  }
  
  internal static var maxNumberOfVouchers = 2
  
  internal static var groupConfig: GroupConfig?
}
