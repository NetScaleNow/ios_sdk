//
//  VoucherDetailViewController.swift
//  Pods
//
//  Created by Jonas Stubenrauch on 23.05.17.
//
//

import UIKit

class VoucherDetailViewController: UIViewController {
  
  let api: ApiService = ApiServiceImpl.shared
  
  var voucher: Voucher!
  var metadata: Metadata!
  var closeCallback: (() -> Void)?
  
  @IBOutlet var useVoucherButton: UIButton!
  @IBOutlet var newsletterContainer: UIView!
  @IBOutlet var checkbox: CheckboxView!
  @IBOutlet var newsletterTitle: UILabel!
  @IBOutlet var newsletterSubTitle: UILabel!
  @IBOutlet var newsletterButton: UIButton!
  @IBOutlet var voucherCodeTitle: UILabel!
  @IBOutlet var mailHint: UILabel!
  @IBOutlet var voucherCode: UITextField!
  @IBOutlet var activityIndicator: UIActivityIndicatorView!
  @IBOutlet var checkboxContainer: UIStackView!
  @IBOutlet var contentStackView: UIStackView!;
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    contentStackView.axis = traitCollection.verticalSizeClass == .compact ? .horizontal : .vertical;
    
    customFont()
    
    updateUI()
    updateStrings()

    voucherCode.text = voucher.code
    checkbox.checkedDidChange = { checked in
      if !self.checkbox.valid {
        self.checkbox.valid = checked
      }
    }
  }
  
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    if identifier == "backToOverview" {
      return voucher.subscribedToNewsletter
    }
    
    return true
  }
  
  private func customFont() {
    UIFont.registerFontWithFilenameString(filenameString: "AbrilFatface-Regular.ttf")
  }
  
  fileprivate func updateUI() {
    useVoucherButton.isHidden = voucher.campaign?.shopLink == nil
    useVoucherButton.setTitleColor(Config.tintColor, for: .normal)
    newsletterButton.titleLabel?.adjustsFontSizeToFitWidth = true
    newsletterButton.backgroundColor = Config.tintColor
    
    newsletterTitle.font = UIFont(name: "AbrilFatface-Regular", size: 24)
    newsletterSubTitle.font = UIFont(name: "AbrilFatface-Regular", size: 15)
    updateNewsletterSection()
  }
  
  private func updateStrings() {
    voucherCodeTitle.text = Strings.VoucherDetail.voucherCodeTitle
    mailHint.text = Strings.VoucherDetail.voucherViaMailHint
    checkbox.checkboxLabel.text = Strings.VoucherDetail.checkboxText
    checkbox.checkboxLabel.numberOfLines = 3

  }
  
  fileprivate func updateNewsletterSection() {
    
    let vouchersLeft = metadata.numberOfRequestedVouchers < Config.maxNumberOfVouchers
    
    if vouchersLeft {
        newsletterTitle.isHidden = false
        newsletterButton.isHidden = false
        if voucher.subscribedToNewsletter {
            checkboxContainer.isHidden = true
            newsletterTitle.text = Strings.VoucherDetail.subscribedNewsletterTitle
            newsletterSubTitle.text = Strings.VoucherDetail.subscribedNewsletterSubTitle
            newsletterButton.setTitle(Strings.VoucherDetail.backToCampaignList, for: .normal)
        } else{
            
            checkboxContainer.isHidden = false
            newsletterTitle.text = Strings.VoucherDetail.noNewsletterTitle
            newsletterSubTitle.text = Strings.VoucherDetail.noNewsletterSubTitle
            newsletterButton.setTitle(Strings.VoucherDetail.subscribeToNewsletter, for: .normal)
        }
    } else {
        newsletterTitle.isHidden = true
        newsletterButton.isHidden = true
        checkboxContainer.isHidden = true
        newsletterSubTitle.text = Strings.VoucherDetail.noVouchersLeftMessage
    }
  }
}

extension VoucherDetailViewController {
  @IBAction
  func registerForNewsletter() {
    if voucher.subscribedToNewsletter {
      return
    }
    
    guard checkbox.checked else {
      checkbox.valid = false
      return
    }
    
    
    activityIndicator.startAnimating()
    newsletterButton.isUserInteractionEnabled = false
    newsletterButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)

    api.subscribeToNewsletter(metadata: metadata) { (success, error) in
      
      self.activityIndicator.stopAnimating()
      self.newsletterButton.isUserInteractionEnabled = true
      self.newsletterButton.titleEdgeInsets = .zero
      
      if success {
        self.voucher.subscribedToNewsletter = true
        self.updateNewsletterSection()
      }
    }
  }
  
  @IBAction
  func useVoucher() {
    guard let urlString = self.voucher?.campaign?.shopLink,
      let shopUrl = URL(string: urlString)
    else {
      return
    }
    
    let alert = UIAlertController(title: Strings.VoucherDetail.OpenShopAlert.title,
                                  message: Strings.VoucherDetail.OpenShopAlert.message,
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: Strings.VoucherDetail.OpenShopAlert.cancel, style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: Strings.VoucherDetail.OpenShopAlert.open, style: .default, handler: {_ in
      UIPasteboard.general.string = self.voucher.code
      UIApplication.shared.openURL(shopUrl)
    }))
    
    present(alert, animated: true, completion: nil)
  }
  
  @IBAction
  func close() {
    closeCallback?()
  }
}

extension VoucherDetailViewController : UITextFieldDelegate {
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    return false
  }
}

public extension UIFont {
  public static func registerFontWithFilenameString(filenameString: String) {
    let bundle = Config.bundle
    
    guard let pathForResourceString = bundle.path(forResource: filenameString, ofType: nil) else {
      print("UIFont+:  Failed to register font - path for resource not found.")
      return
    }
    
    guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
      print("UIFont+:  Failed to register font - font data could not be loaded.")
      return
    }
    
    guard let dataProvider = CGDataProvider(data: fontData) else {
      print("UIFont+:  Failed to register font - data provider could not be loaded.")
      return
    }
    
    let font = CGFont(dataProvider)
    CTFontManagerRegisterGraphicsFont(font!, nil)
  }
}
