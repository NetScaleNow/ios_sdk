//
//  CheckboxView.swift
//  Pods
//
//  Created by Jonas Stubenrauch on 01.06.17.
//
//

import UIKit

class CheckboxView: ReusableView {

  var checkedDidChange: ((Bool) -> Void)?
  var checkboxLabelTapped: (() -> Void)?
  
  var valid: Bool = true {
    didSet {
      if valid {
        checkbox.tintColor = Config.tintColor;
      } else {
        checkbox.tintColor = .red;
      }
    }
  }
  
  var checked = false {
    didSet {
      checkbox.isSelected = checked
    }
  }
  @IBAction func labelTapped(_ sender: UITapGestureRecognizer) {
    checkboxLabelTapped?()
  }
  
  @IBOutlet var checkbox: UIButton!
  @IBOutlet var checkboxLabel: UILabel!
  
  @IBAction func checkboxChange(_ sender: UIButton) {
    checked = !checked
    checkedDidChange?(sender.isSelected)
  }
}
