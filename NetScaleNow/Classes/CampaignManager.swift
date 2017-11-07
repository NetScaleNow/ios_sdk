//
//  CampaignManager.swift
//  Pods
//
//  Created by Jonas Stubenrauch on 18.05.17.
//
//

import Foundation


public class CampaignManager: NSObject {
  
  internal static let shared = CampaignManager()
  
  static let api: ApiService = ApiServiceImpl.shared
  
  /// Use this method to trigger the Campaign/Voucher selection. If no vouchers are available, the UI won't be shown.
  ///
  /// - Parameters:
  ///   - metadata: optional, metadata about the user.
  ///   - greeting: optional greeting text replacing 'Vielen Dank für ihren Einkauf'
  ///   - greetingMessage: optional gretting message replacing the default one
  ///   - callback: optional, called after the user has dismissed the ui
  public static func showCampaigns(metadata: Metadata = Metadata(), greeting: String? = nil, greetingMessage: String? = nil, callback: (() -> Void)? = nil) {
    
    metadata.numberOfRequestedVouchers = 0
    
    api.campaigns(metadata: metadata) { campaigns, error in
      
      guard let campaigns = campaigns else {
        print("Api error. Not showing campaign list")
        callback?()
        return
      }
      
      if (campaigns.count == 0) {
        print("No campaigns available. Not showing campaign list")
        callback?()
        return
      }
      
      let storyboad = UIStoryboard(name: "Storyboard", bundle: Config.bundle)
      let navigationController = storyboad.instantiateInitialViewController() as! UINavigationController
      navigationController.transitioningDelegate = shared
      navigationController.modalPresentationStyle = .custom
      navigationController.view.tintColor = Config.tintColor
      
      let viewController = UIApplication.shared.topMostViewController()!
      
      let campaignList = navigationController.viewControllers.first as! CampaignListViewController
      campaignList.campaigns = campaigns
      campaignList.metadata = metadata
      campaignList.greeting = greeting
      campaignList.greetingMessage = greetingMessage
      
      campaignList.closeCallback = {
        viewController.dismiss(animated: true, completion: { 
          callback?()
        })
      }
      
      viewController.present(navigationController, animated: true, completion: nil)
    }
    
  }
}

extension UIViewController {
  func topMostViewController() -> UIViewController {
    if self.presentedViewController == nil {
      return self
    }
    if
      let navigation = self.presentedViewController as? UINavigationController,
      let visibleViewController = navigation.visibleViewController {
      return visibleViewController.topMostViewController()
    }
    if let tab = self.presentedViewController as? UITabBarController {
      if let selectedTab = tab.selectedViewController {
        return selectedTab.topMostViewController()
      }
      return tab.topMostViewController()
    }
    return self.presentedViewController!.topMostViewController()
  }
}

extension UIApplication {
  func topMostViewController() -> UIViewController? {
    return self.keyWindow?.rootViewController?.topMostViewController()
  }
}

extension CampaignManager: UIViewControllerTransitioningDelegate {
  
  public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    return CampaignPresentationController(presentedViewController: presented, presenting: presenting)
  }
}
