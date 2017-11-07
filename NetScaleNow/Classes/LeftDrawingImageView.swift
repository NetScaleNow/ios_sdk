//
//  LeftDrawingImageView.swift
//  Pods
//
//  Created by Moritz on 15.08.17.
//
//

import Foundation

class LeftDrawingImageView : UIView {
  
  var imageView = UIImageView()
  

  
  func setImage ( image : String ){
    self.imageView.setImageFrom(url: URL(string: image)!) { imageResult in
      self.setNeedsLayout()
      self.layoutIfNeeded()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(imageView)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    if (self.imageView.image == nil){
      return
    }
    let coefficientH = self.frame.height / self.imageView.image!.size.height
    let coefficientW = self.frame.width / self.imageView.image!.size.width
    
    let coefficient = min(coefficientH, coefficientW)
    
    let newWidth = self.imageView.image!.size.width * coefficient
    
    self.imageView.frame = CGRect(x: 0, y: 0, width: newWidth, height: self.frame.height)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    addSubview(imageView)
    imageView.contentMode = .scaleAspectFit

  }
}
