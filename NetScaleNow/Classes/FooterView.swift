//
//  FooterView.swift
//  Pods
//
//  Created by Jonas Stubenrauch on 01.06.17.
//
//

import UIKit

class FooterView: ReusableView {
  
  @IBOutlet var agbLink: UIButton! {
    didSet {
      agbLink.setTitle(Strings.General.agbLink, for: .normal)
    }
  }
  
  @IBOutlet var dataProtectionLink: UIButton! {
    didSet {
      dataProtectionLink.setTitle(Strings.General.dataProtectionLink, for: .normal)
    }
  }
  
  @IBOutlet var copyrightLink: UIButton! {
    didSet {
      copyrightLink.setTitle(Strings.General.copyrightLink, for: .normal)
    }
  }
  
  @IBAction func openAGB() {
    UIApplication.shared.openURL(URL(string: Strings.General.agbUrl)!)
  }
  
  @IBAction func openDataProtection() {
    UIApplication.shared.openURL(URL(string: Strings.General.dataProtectionUrl)!)
  }
  
  @IBAction func openCMC() {
    UIApplication.shared.openURL(URL(string: Strings.General.copyrightUrl)!)
  }
}


