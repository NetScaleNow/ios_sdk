//
//  CampaignCollectionViewCell.swift
//  Pods
//
//  Created by Jonas Stubenrauch on 18.05.17.
//
//

import UIKit
import Foundation

class CampaignCollectionViewCell: UICollectionViewCell {
  
  var heightChangeCallback: (() -> Void)?
  
//  @IBOutlet
//  var image: UIImageView!
//  
  @IBOutlet
  var discount: UILabel!
  
  @IBOutlet
  var imageView: LeftDrawingImageView!
  
  
  @IBOutlet
  var arrow: UIImageView! {
    didSet {
      arrow.tintColor = Config.tintColor
    }
  }
  
  @IBOutlet
  var separator: UIView!
  
  @IBOutlet
  var detailContainer: UIView!
  
  
  @IBOutlet
  var limitations: UILabel!
  
  
  var showDetails = false {
    didSet {
      if (limitations.text != nil && limitations.text!.lengthOfBytes(using: .utf8) > 0){
      detailContainer.isHidden = !showDetails
      } else {
        detailContainer.isHidden = true
      }
    }
  }
  
  @IBAction
  func toggleDetails() {
    showDetails = !showDetails
    heightChangeCallback?()
  }
  
  
  override func prepareForReuse() {
    super.prepareForReuse()
    showDetails = false
  }
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    showDetails = false
    contentView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  var widthConstraint: NSLayoutConstraint?
  var aspectRatioConstraint: NSLayoutConstraint?
  
  override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    
    let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
    
    preferredWidth = attributes.frame.size.width
    
    return attributes
  }
  
  var preferredWidth: CGFloat? {
    didSet {
      guard let preferredWith = preferredWidth else {
        return
      }
      if widthConstraint == nil {
        widthConstraint = contentView.widthAnchor.constraint(equalToConstant: preferredWith)
        widthConstraint?.isActive = true
      }
      widthConstraint?.constant = preferredWith
    }
  }
}

extension CampaignCollectionViewCell {
  func show(campaign: Campaign) {
    discount.text = campaign.discount
    limitations.text = campaign.limitations
    
    if (limitations.text != nil && limitations.text!.lengthOfBytes(using: .utf8) == 0){
      limitations.text = campaign.limitationsDescription
    }
    if let logoUrl = campaign.resizedLogoUrl {
      imageView.setImage(image: logoUrl)

    }
  }
}
