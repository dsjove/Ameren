//
//  TransitioningDelegate.swift
//  Ameren
//
//  Created by David Giovannini on 5/29/15.
//  Copyright (c) 2016 Object Computing Inc. All rights reserved.
//

import UIKit

public class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController:presented, presenting:presenting)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animationController = AnimatedTransitioning()
        animationController.isPresentation = true
        return animationController
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animationController = AnimatedTransitioning()
        animationController.isPresentation = false
        return animationController
    }
}
