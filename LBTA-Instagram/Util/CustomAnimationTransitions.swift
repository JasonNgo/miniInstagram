//
//  CustomAnimationTransitions.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-09-02.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class CustomAnimationPresentor: NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.5
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView
    guard let fromContainerView = transitionContext.view(forKey: .from) else { return }
    guard let toContainerView = transitionContext.view(forKey: .to) else { return }
    containerView.addSubview(toContainerView)
    
    let startingFrame = CGRect(x: -toContainerView.frame.width, y: 0, width: toContainerView.frame.width, height: toContainerView.frame.height)
    toContainerView.frame = startingFrame
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
      fromContainerView.frame = CGRect(x: fromContainerView.frame.width, y: 0, width: containerView.frame.width, height: containerView.frame.height)
      toContainerView.frame = CGRect(x: 0, y: 0, width: toContainerView.frame.width, height: toContainerView.frame.height)
    }) { (_) in
      transitionContext.completeTransition(true)
    }
  }
  
}

class CustomAnimationDismisser: NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.5
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView
    guard let fromContainerView = transitionContext.view(forKey: .from) else { return }
    guard let toContainerView = transitionContext.view(forKey: .to) else { return }
    containerView.addSubview(toContainerView)
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
      fromContainerView.frame = CGRect(x: -fromContainerView.frame.width, y: 0, width: containerView.frame.width, height: containerView.frame.height)
      toContainerView.frame = CGRect(x: 0, y: 0, width: toContainerView.frame.width, height: toContainerView.frame.height)
    }) { (_) in
      transitionContext.completeTransition(true)
    }
  }
  
}
