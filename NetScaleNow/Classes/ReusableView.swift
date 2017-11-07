//
//  ReusableView.swift
//  Pods
//
//  Created by Jonas Stubenrauch on 01.06.17.
//
//

import UIKit

class ReusableView: UIView {

  var contentView : UIView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    xibSetup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    xibSetup()
  }
  
  func xibSetup() {
    contentView = loadViewFromNib()
    contentView.frame = bounds
    
    // Make the view stretch with containing view
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addSubview(contentView!)
  }
  
  func loadViewFromNib() -> UIView! {
    
    let bundle = Config.bundle
    let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
    let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    
    return view
  }

}
