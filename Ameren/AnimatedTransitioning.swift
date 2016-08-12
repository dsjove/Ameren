//
//  AnimatedTransitioning.swift
//  Ameren
//
//  Created by David Giovannini on 5/29/15.
//  Copyright (c) 2016 Object Computing Inc. All rights reserved.
//

import UIKit

public class AnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var isPresentation : Bool = false
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextFromViewControllerKey)!
        let toVC = transitionContext.viewController(forKey: UITransitionContextToViewControllerKey)!
        let fromView = fromVC.view
        let toView = toVC.view
        let containerView = transitionContext.containerView
        
        if isPresentation {
            containerView.addSubview(toView!)
        }
        
        let animatingVC = isPresentation ? toVC : fromVC
        let animatingView = animatingVC.view
        
        let finalFrameForVC = transitionContext.finalFrame(for: animatingVC)
        var initialFrameForVC = finalFrameForVC
        initialFrameForVC.origin.x += initialFrameForVC.size.width
        
        let initialFrame = isPresentation ? initialFrameForVC : finalFrameForVC
        let finalFrame = isPresentation ? finalFrameForVC : initialFrameForVC
        
        animatingView?.frame = initialFrame
        
        UIView.animate(
			withDuration: transitionDuration(using: transitionContext),
			delay:0, usingSpringWithDamping:300.0,
			initialSpringVelocity: 5.0,
			options: UIViewAnimationOptions.allowUserInteraction,
			animations: {
				animatingView?.frame = finalFrame
            }, completion: { _ in
                if !self.isPresentation {
                    fromView?.removeFromSuperview()
                }
                transitionContext.completeTransition(true)
			})
    }
}
