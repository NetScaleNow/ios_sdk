//
//  CampaignPresentationController.swift
//  Pods
//
//  Created by Jonas Stubenrauch on 18.05.17.
//
//

import UIKit

class CampaignPresentationController: UIPresentationController {
  
  
  private var dimmingView: UIView!
  private var keyboardHeight: CGFloat = 0
  private var keyboardHeightScaleFactor: CGFloat = 0.7
  
  override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    
    NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil, queue: OperationQueue.main) { (notification) in
      if let frame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect,
        let containerView = self.containerView {
        self.keyboardHeight = containerView.frame.height - frame.origin.y
        if self.keyboardHeight > 0 {
          self.presentedView?.frame.origin.y -= frame.height * self.keyboardHeightScaleFactor
        } else {
          self.presentedView?.frame.origin.y += frame.height * self.keyboardHeightScaleFactor
        }
      }
    }
    
  }
  
  override func presentationTransitionWillBegin() {
    guard let containerView = containerView else {
      return
    }
    
    dimmingView = UIView(frame: containerView.bounds)
    dimmingView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    dimmingView.alpha = 0
    dimmingView.backgroundColor = .black
    containerView.insertSubview(dimmingView, at: 0)
    
    presentedView?.layer.cornerRadius = 8
    presentedView?.clipsToBounds = true
    
    guard let coordinator = presentedViewController.transitionCoordinator else {
      dimmingView.alpha = 0.4
      return
    }
    
    coordinator.animate(alongsideTransition: { _ in
      self.dimmingView.alpha = 0.4
    })
  }
  
  override func dismissalTransitionWillBegin() {
    guard let coordinator = presentedViewController.transitionCoordinator else {
      dimmingView.alpha = 0
      return
    }
    
    coordinator.animate(alongsideTransition: { _ in
      self.dimmingView.alpha = 0
    })
  }
  
  override func dismissalTransitionDidEnd(_ completed: Bool) {
    if (completed) {
      dimmingView.removeFromSuperview()
    }
  }
  
  let containerHeight: CGFloat = 550
  let containerWidth: CGFloat = 320
  let containerWidthCompact: CGFloat = 550
  let containerHeightCompact: CGFloat = 300
  
  override var frameOfPresentedViewInContainerView: CGRect {
    guard let containerView = containerView else {
      return super.frameOfPresentedViewInContainerView
    }
    
    let widthInset: CGFloat
    var heightInset: CGFloat
    
    if (traitCollection.verticalSizeClass == .regular) {
      widthInset = (containerView.frame.width - containerWidth) / 2
      heightInset = (containerView.frame.height - containerHeight) / 2
    } else {
      widthInset = (containerView.frame.width - containerWidthCompact) / 2
      heightInset = (containerView.frame.height - containerHeightCompact) / 2
    }
    
    
    var frame = containerView.frame.insetBy(dx: widthInset, dy: heightInset)
    if (keyboardHeight > 0) {
      frame.origin.y -= keyboardHeight * self.keyboardHeightScaleFactor
      
    }
    return frame
  }
  
  override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
    
    if container === self.presentedViewController {
      if (parentSize.width > parentSize.height && traitCollection.userInterfaceIdiom == .phone) {
        return CGSize(width: containerWidthCompact, height: containerHeightCompact)
      } else {
        return CGSize(width: containerWidth, height: containerHeight)
      }
    }
    return super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
  }
  
  override var shouldPresentInFullscreen: Bool {
    return false
  }
  
  override func containerViewWillLayoutSubviews() {
    presentedView?.frame = frameOfPresentedViewInContainerView
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    presentedView?.frame = frameOfPresentedViewInContainerView
  }
}
