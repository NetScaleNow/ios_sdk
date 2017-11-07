//
//  CampaignDetailViewController.swift
//  Pods
//
//  Created by Jonas Stubenrauch on 19.05.17.
//
//

import UIKit

class CampaignDetailViewController: UIViewController {
  
  var campaign: Campaign!
  var metadata: Metadata!
  var closeCallback: (() -> Void)?
  
  let api: ApiService = ApiServiceImpl.shared
  
  @IBOutlet var logo: LeftDrawingImageView!
  @IBOutlet var header: UIImageView!
  @IBOutlet var email: UITextField!
  @IBOutlet var value: UILabel!
  @IBOutlet var pageIndicator: UIPageControl!
  @IBOutlet var closeButton: UIButton!
  @IBOutlet var detailText: UITextView!
  @IBOutlet var keyboardConstraint: NSLayoutConstraint!
  @IBOutlet var request: UIButton!
  @IBOutlet var back: UIButton!
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var voucherInformationTitle: UILabel!
  @IBOutlet var checkbox : CheckboxView!
  @IBOutlet var activityIndicator: UIActivityIndicatorView!
  @IBOutlet var contentStackView: UIStackView!;
  
  override func viewDidLoad() {
    super.viewDidLoad()

    contentStackView.axis = traitCollection.verticalSizeClass == .compact ? .horizontal : .vertical;
    
    api.campaign(metadata: metadata, campaign: campaign) { (_, _) in
      
    }
    
    updateUI()
    updateStrings()
    updateData()
    checkbox.checkedDidChange = { checked in
      if !self.checkbox.valid {
        self.checkbox.valid = checked
      }
    }
    
    checkbox.checkboxLabelTapped = {
      let action = UIAlertController(title: Strings.CampaignDetail.TermsActionSheet.title, message: nil, preferredStyle: .actionSheet)
      action.addAction(UIAlertAction(title: Strings.CampaignDetail.TermsActionSheet.optionAccept, style: .default, handler: { _ in
        self.checkbox.checked = true
      }))
      action.addAction(UIAlertAction(title: Strings.CampaignDetail.TermsActionSheet.optionShowUsageTerms, style: .default, handler: { _ in
        UIApplication.shared.openURL(URL(string: Strings.General.checkboxUsageTermsUrl)!)
      }))
      action.addAction(UIAlertAction(title: Strings.CampaignDetail.TermsActionSheet.optionShowPrivacyTerms, style: .default, handler: { _ in
        UIApplication.shared.openURL(URL(string: Strings.General.checkboxPrivacyTermsUrl)!)
      }))
      action.addAction(UIAlertAction(title: Strings.CampaignDetail.TermsActionSheet.cancel, style: .cancel, handler: nil))
      
      action.popoverPresentationController?.sourceView = self.checkbox;
      action.popoverPresentationController?.sourceRect = self.checkbox.bounds;
      action.popoverPresentationController?.permittedArrowDirections = [.up]
      action.view.tintColor = Config.tintColor
      self.present(action, animated: true, completion: nil)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let viewController = segue.destination as? VoucherDetailViewController,
      let voucher = sender as? Voucher {
      viewController.voucher = voucher
      viewController.metadata = metadata
      viewController.closeCallback = closeCallback
    }
  }
  
  func updateUI() {
    closeButton.layer.cornerRadius = closeButton.frame.width / 2
    back.layer.cornerRadius = back.frame.width / 2
    request.backgroundColor = Config.tintColor
        
    pageIndicator.currentPageIndicatorTintColor = Config.tintColor
    pageIndicator.layer.shadowOffset = CGSize(width: 0, height: 0)
    pageIndicator.layer.shadowRadius = 1
    pageIndicator.layer.shadowColor = UIColor.black.cgColor
    pageIndicator.layer.shadowOpacity = 1
  }
  
  fileprivate func isValidEmail(testStr: String?) -> Bool {
    guard let testStr = testStr else {
      return false
    }
    
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
  }
  
  fileprivate func showEmailValidation() {
    if (!isValidEmail(testStr: email.text)) {
      email.layer.borderColor = UIColor.red.cgColor
      email.layer.borderWidth = 1
      email.layer.cornerRadius = 4
    } else {
      email.layer.borderWidth = 0
    }
  }
  
  private func updateStrings() {
    
    let text = Strings.CampaignDetail.checkboxText
    let nsText = text as NSString
    let textRange = NSMakeRange(0, nsText.length)
    let attributedString = NSMutableAttributedString(string: text)
    
    nsText.enumerateSubstrings(in: textRange, options: .byWords, using: {
      (substring, substringRange, _, _) in
      
      if (substring == Strings.CampaignDetail.checkboxTextToHighlightUsage || substring == Strings.CampaignDetail.checkboxTextToHighlightData ) {
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: substringRange)
      }
    })
    
    checkbox.checkboxLabel.attributedText = attributedString
    request.setTitle(Strings.CampaignDetail.showVoucher, for: .normal)
    email.placeholder = Strings.CampaignDetail.emailPlaceholder
    voucherInformationTitle.text = Strings.CampaignDetail.voucherInformation
  }
  
  var aspectRatioConstraint: NSLayoutConstraint?

  private func updateData() {
    
    email.text = metadata.email
    value.text = Strings.CampaignDetail.discountFormat(discount: campaign.discount)
    detailText.text = campaign.limitationsDescription
    
    if let logoUrl = campaign.resizedLogoUrl, !logoUrl.isEmpty {
      logo.imageView.setImageFrom(urlString: logoUrl)
    }
    
    if let headerUrl = campaign.resizedHeaderUrl, !headerUrl.isEmpty {
      header.setImageFrom(urlString: headerUrl)
    }
  }
  
  fileprivate func showErrorAlert() {
    print("Error while requesting voucher.")
    let alert = UIAlertController(title: "", message: Strings.General.errorMessage, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: Strings.General.close, style: .default, handler: nil))
    
    present(alert, animated: true, completion: nil)
  }
}

extension CampaignDetailViewController {
  
  @IBAction
  func changePage(_ sender: UIPageControl) {
    let x = sender.currentPage == 1 ? scrollView.frame.width : 0
    scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
  }
  
  @IBAction func emailChanged() {
    metadata.email = email.text
    
    if (email.layer.borderWidth == 1) {
      showEmailValidation()
    }
  }
  
  @IBAction func close() {
    closeCallback?()
  }
  
  @IBAction func showInfo() {
    pageIndicator.currentPage = 1
    changePage(pageIndicator)
  }
  
  @IBAction func requestVoucher() {
    
    var valid = true
    if !checkbox.checked {
      checkbox.valid = false
      valid = false
    }
    
    if !isValidEmail(testStr: metadata.email) {
      showEmailValidation()
      valid = false
    }
    
    guard valid else {
      return
    }
    
    
    activityIndicator.startAnimating()
    request.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
    request.isUserInteractionEnabled = false
    api.requestVoucher(metadata: metadata, campaign: campaign) { (voucher, error) in
      self.activityIndicator.stopAnimating()
      self.request.isUserInteractionEnabled = true
      self.request.titleEdgeInsets = UIEdgeInsets.zero
      
      guard let voucher = voucher, error == nil else {
        self.showErrorAlert()
        return
      }
      self.metadata.numberOfRequestedVouchers += 1
      self.performSegue(withIdentifier: "showVoucherCode", sender: voucher)
      
    }
  }
}

extension CampaignDetailViewController: UIScrollViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    pageIndicator.currentPage = scrollView.contentOffset.x > 0.5 * scrollView.frame.width ? 1 : 0
  }
}

extension CampaignDetailViewController : UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
