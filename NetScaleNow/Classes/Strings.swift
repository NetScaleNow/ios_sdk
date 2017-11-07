//
//  Strings.swift
//  Pods
//
//  Created by Jonas Stubenrauch on 23.05.17.
//
//

import Foundation

struct Strings {
  private static let bundle = Config.bundle
  
  struct General {
    static var close : String {
        return NSLocalizedString("General.close", bundle: bundle, value: "Schließen", comment: "Title of a close button")
    }
    
    static var errorMessage : String {
        return NSLocalizedString("General.errorMessage", bundle: bundle, value: "Es ist ein technischer Fehler aufgetreten. Bitte versuchen Sie es in Kürze erneut oder wenden Sie sich an kontakt@premium-shopping.de.", comment: "Generic error message")
    }
    
    static var backToCampaignList : String {
      return NSLocalizedString("General.backToCampaignList", bundle: bundle, value: "Zurück zur Übersicht", comment: "Title of the button to go back to the campaign list")
    }
    
    static var agbLink : String {
      return NSLocalizedString("CampaignDetail.agbLink", bundle: bundle, value: "AGB", comment: "Title of the link to open the AGB (Terms of Conditions) ")
    }
    
    static var dataProtectionLink : String {
      return NSLocalizedString("CampaignDetail.dataProtectionLink", bundle: bundle, value: "Datenschutz", comment: "Title of the link to open the data protection ")
    }
    
    static var copyrightLink : String {
      guard let copyrightLink = Config.groupConfig?.copyrightText else {
        return NSLocalizedString("CampaignDetail.copyrightLink", bundle: bundle, value: "© Premium Shopping", comment: "Title of the link showing the copy right")
      }
      return copyrightLink
    }
    
    static var agbUrl : String {
      guard let agbUrl = Config.groupConfig?.termsLink else {
        return NSLocalizedString("CampaignDetail.agbUrl", bundle: bundle, value: "https://www.premium-shopping.de/agb", comment: "Url to the AGB (Terms of Conditions) ")
      }
      return agbUrl
    }
    
    static var dataProtectionUrl : String {
      guard let dataProtectionUrl = Config.groupConfig?.privacyPolicyLink else {
        return NSLocalizedString("CampaignDetail.dataProtectionUrl", bundle: bundle, value: "https://www.premium-shopping.de/datenschutz", comment: "Url to the data protection")
      }
      return dataProtectionUrl
    }
    
    static var checkboxPrivacyTermsUrl : String {
      guard let checkboxPrivacyTermsUrl = Config.groupConfig?.privacyPolicyLink else {
        return NSLocalizedString("CampaignDetail.checkboxPrivacyTermsUrl", bundle: bundle, value: "http://www.premium-shopping.de/datenschutz", comment: "Url to the privacy terms (Datenschutzbedingungen) next to the checkbox")
      }
      return checkboxPrivacyTermsUrl
    }
    
    static var checkboxUsageTermsUrl : String {
      guard let checkboxUsageTermsUrl = Config.groupConfig?.termsLink else {
        return NSLocalizedString("CampaignDetail.checkboxUsageTermsUrl", bundle: bundle, value: "http://www.premium-shopping.de/agb", comment: "Url to the usage terms (Nutzungsbedingungen) next to the checkbox")
      }
      return checkboxUsageTermsUrl
    }
    
    static var copyrightUrl : String {
      guard let copyrightUrl = Config.groupConfig?.copyrightLink else {
        return NSLocalizedString("CampaignDetail.copyrightUrl", bundle: bundle, value: "https://www.premium-shopping.de", comment: "Url to copy right")
      }
      return copyrightUrl
    }
  }
  
  struct CampaignList {
    static var headline : String {
      guard let headline = Config.groupConfig?.campaignListTitle.uppercased().brReplaced() else {
        return NSLocalizedString("CampaignList.headline", bundle: bundle, value: "VIELEN DANK FÜR IHREN EINKAUF!", comment: "Headline of the Campaign Selection View")
      }
      return headline
    }
    
    static var message : String {
      guard let message = Config.groupConfig?.campaignListSubtitle.brReplaced() else {
      return NSLocalizedString("CampaignList.message", bundle: bundle, value: "Als Dankeschön dürfen Sie sich einen Gratisgutschein aussuchen. ", comment: "Message below the Headline of the Campaign Selection View")
      }
      return message
    }
  }
  
  struct CampaignDetail {
    
    private static var discountFormat: String {
      return NSLocalizedString("CampaignDetail.discountFormat", bundle: bundle, value: "%@ Gutschein*", comment: "Discount Value of the Campaign together with Voucher. %@ is replaced with the actual value")
    }
    static func discountFormat(discount: String) -> String {
      return String(format: discountFormat, discount)
    }
    
    static var voucherInformation : String {
      return NSLocalizedString("CampaignDetail.voucherRestrictions", bundle: bundle, value: "*Gutscheinbedingungen", comment: "Title of the voucher information text")
    }
    
    static var checkboxText : String {
      return NSLocalizedString("CampaignDetail.checkboxText", bundle: bundle, value: "Ja, hiermit bestätige ich, dass ich die Nutzungs- und Datenschutzbedingungen gelesen und akzeptiert habe.", comment: "Text shown next to the checkbox.")
    }
    
    static var checkboxTextToHighlightUsage : String {
      return NSLocalizedString("CampaignDetail.checkboxTextToHighlightUsage", bundle: bundle, value: "Nutzungs", comment: "Part of the checkbox text that should be underlined for usage rules")
    }
    
    static var checkboxTextToHighlightData : String {
      return NSLocalizedString("CampaignDetail.checkboxTextToHighlightData", bundle: bundle, value: "Datenschutzbedingungen", comment: "Part of the checkbox text that should be underlined for data protection")
    }
    
    static var emailPlaceholder : String {
      return NSLocalizedString("CampaignDetail.emailPlaceholder", bundle: bundle, value: "E-Mail-Adresse eingeben", comment: "Placeholder for the email input field. Only shows if no email is entered")
    }
    
    static var showVoucher : String {
      return NSLocalizedString("CampaignDetail.showVoucher", bundle: bundle, value: "GUTSCHEINCODE ANZEIGEN", comment: "Title of the button to request a voucher.")
    }
    
    static var backToOverview : String {
      return NSLocalizedString("CampaignDetaill.backToOverview", bundle: bundle, value: "« zurück zur Übersicht", comment: "Title of the button to go back to the campaign list.")
    }
    
    struct TermsActionSheet {
      static var title : String {
        return NSLocalizedString("CampaignDetaill.TermsActionSheet.title", bundle: bundle, value: "Action wählen", comment: "Title of the terms action sheet.")
      }
      
      static var cancel : String {
        return NSLocalizedString("CampaignDetaill.TermsActionSheet.cancel", bundle: bundle, value: "Abbrechen", comment: "Title of the cancel action of the terms action sheet.")
      }
      
      static var optionAccept : String {
        return NSLocalizedString("CampaignDetaill.TermsActionSheet.optionAccept", bundle: bundle, value: "Bedingungen akzeptieren", comment: "Option to accept the terms.")
      }
      
      static var optionShowUsageTerms : String {
        return NSLocalizedString("CampaignDetaill.TermsActionSheet.optionShowUsageTerms", bundle: bundle, value: "Nutzungsbedingungen anzeigen", comment: "Option to show usage terms.")
      }
      
      static var optionShowPrivacyTerms : String {
        return NSLocalizedString("CampaignDetaill.TermsActionSheet.optionShowPrivacyTerms", bundle: bundle, value: "Datenschutzbedingungen anzeigen", comment: "Option to show privacy terms.")
      }
      
    }
  }
  
  struct VoucherDetail {
    static var noNewsletterTitle : String {
      guard let noNewsletterTitle = Config.groupConfig?.newsletterTitle.brReplaced() else {
      return NSLocalizedString("VoucherDetail.noNewsletterTitle", bundle: bundle, value: "Jetzt zweiten Gutschein aussuchen?", comment: "Title if user has not subscribed to the newsletter yet.")
      }
      return noNewsletterTitle
    }
    
    static var noNewsletterSubTitle : String {
      guard let noNewsletterSubTitle = Config.groupConfig?.newsletterSubtitle.brReplaced() else {
      return NSLocalizedString("VoucherDetail.noNewsletterSubTitle", bundle: bundle, value: "Einfach zum Newsletter anmelden!", comment: "Message below the Title if user has not subscribed to the newsletter yet.")
      }
      return noNewsletterSubTitle
    }
    
    static var subscribeToNewsletter : String {
      return NSLocalizedString("VoucherDetail.subscribeToNewsletter", bundle: bundle, value: "ANMELDEN", comment: "Title of the button to subscribe to the newsletter.")
    }
    
    static var subscribedNewsletterTitle : String {
      guard let subscribedNewsletterTitle = Config.groupConfig?.nextVoucherTitle.brReplaced() else {
      return NSLocalizedString("VoucherDetail.subscribedNewsletterTitle", bundle: bundle, value: "Sie wollen noch mehr sparen beim Shoppen?", comment: "Title if user has subscribed to the newsletter.")
      }
      return subscribedNewsletterTitle
    }
    
    static var subscribedNewsletterSubTitle : String {
      guard let subscribedNewsletterSubTitle = Config.groupConfig?.nextVoucherSubtitle.brReplaced() else {
      return NSLocalizedString("VoucherDetail.subscribedNewsletterSubTitle", bundle: bundle, value: "Suchen Sie sich exklusiv einen weiteren Gutschein aus!", comment: "Message below the Title if user has subscribed to the newsletter.")
      }
      return subscribedNewsletterSubTitle
    }
    
    static var noVouchersLeftMessage : String {
      guard let noVouchersLeftMessage = Config.groupConfig?.maximumReachedText.brReplaced() else {
        return NSLocalizedString("VoucherDetail.noVouchersLeftMessage", bundle: bundle, value: "Sie haben die maximale Anzahl an Gutscheinen erreicht.\nWir halten Sie über neue Gutscheine per Newsletter auf dem Laufenden.\nViel Spaß beim Shoppen!", comment: "Title if user has reached the maxium number of vouchers.")
      }
      return noVouchersLeftMessage
    }
    
    static var backToCampaignList : String {
      return NSLocalizedString("VoucherDetail.subscribeToNewsletter", bundle: bundle, value: "ZU DEN GUTSCHEINEN", comment: "Title of the button to go back to the campaign list.")
    }
    
    static var checkboxText : String {
     guard let checkboxText = Config.groupConfig?.userAgreementText.brReplaced() else {
      return NSLocalizedString("VoucherDetail.checkboxText", bundle: bundle, value: "Ja, ich möchte künftig den kostenlosen Premium Shopping Newsletter per E-Mail erhalten. Das Einverständnis kann ich jederzeit widerrufen.", comment: "Text shown next to the checkbox.")
      }
      return checkboxText
    }
    
    static var voucherCodeTitle : String {
      guard let voucherCodeTitle = Config.groupConfig?.voucherTitle.uppercased().brReplaced() else {
      return NSLocalizedString("VoucherDetail.voucherCodeTitle", bundle: bundle, value: "IHR GUTSCHEINCODE", comment: "Title above the voucher code.")
      }
      return voucherCodeTitle
    }
    
    static var linkToShop : String {
      return NSLocalizedString("VoucherDetail.linkToShop", bundle: bundle, value: "Zum Shop »", comment: "Name of the link to the shop of the advertiser.")
    }
    
    static var voucherViaMailHint : String {
      guard let voucherViaMailHint = Config.groupConfig?.voucherNote.brReplaced() else {
      return NSLocalizedString("VoucherDetail.voucherViaMailHint", bundle: bundle, value: "Sie erhalten den Gutschein in wenigen Augenblicken\nzusätzlich per Mail.", comment: "Hint message to indicate the voucher is send via mail.")
      }
      return voucherViaMailHint
    }
    
    struct OpenShopAlert {
      static var title : String {
        return NSLocalizedString("VoucherDetail.OpenShopAlert.title", bundle: bundle, value: "Onlineshop öffnen", comment: "Title of the alert shown before opening the shop url in the browser.")
      }
      
      static var message : String {
        return NSLocalizedString("VoucherDetail.OpenShopAlert.message", bundle: bundle, value: "Sie werden jetzt zum Onlineshop des Anbieters weitergeletet. Der Gutscheincode wird automatisch in die Zwischenablage kopiert.", comment: "Message of the alert shown before opening the shop url in the browser.")
      }
      
      static var cancel : String {
        return NSLocalizedString("VoucherDetail.OpenShopAlert.cancel", bundle: bundle, value: "Abbrechen", comment: "Button of the alert shown before opening the shop url in the browser to not open the shop.")
      }
      
      static var open : String {
        return NSLocalizedString("VoucherDetail.OpenShopAlert.open", bundle: bundle, value: "Öffnen", comment: "Button of the alert shown before opening the shop url in the browser to open the shop.")
      }
    }
    
    
    
  }
}

extension String {
  func brReplaced() -> String {
    return self.replacingOccurrences(of: "<br>", with: "\n")
  }
}
