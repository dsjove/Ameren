//
//  PresentationController.swift
//  Ameren
//
//  Created by David Giovannini on 5/29/15.
//  Copyright (c) 2016 Object Computing Inc. All rights reserved.
//

import UIKit

public class PresentationController: UIPresentationController, UIAdaptivePresentationControllerDelegate {
    
    private let shadowView = UIView()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
		shadowView.backgroundColor = UIColor(white:0.0, alpha:0.4)
        shadowView.alpha = 0.0
        let tap = UITapGestureRecognizer(target: self, action: #selector(PresentationController.shadowViewTapped(_:)))
        shadowView.addGestureRecognizer(tap)
    }
    
    func shadowViewTapped(_ gesture: UIGestureRecognizer) {
        if gesture.state == .ended {
            presentingViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        var presentedViewFrame = CGRect()
        let containerBounds = containerView!.bounds
        presentedViewFrame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerBounds.size)
        presentedViewFrame.origin.x = containerBounds.size.width - presentedViewFrame.size.width
    
        return presentedViewFrame
    }
	
	public override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: CGFloat((floor(parentSize.width / 3.0))), height: parentSize.height)
    }
    
    public override func presentationTransitionWillBegin() {
        shadowView.frame = self.containerView!.bounds
        shadowView.alpha = 0.0
        containerView!.insertSubview(shadowView, at: 0)
        let coordinator = presentedViewController.transitionCoordinator
        if coordinator != nil {
            coordinator!.animate(alongsideTransition: {
                (context:UIViewControllerTransitionCoordinatorContext!) -> Void in
                    self.shadowView.alpha = 1.0
            }, completion:nil)
        } else {
            shadowView.alpha = 1.0
        }
    }
    
    public override func dismissalTransitionWillBegin() {
        let coordinator = presentedViewController.transitionCoordinator
        if coordinator != nil {
            coordinator!.animate(alongsideTransition: {
                (context:UIViewControllerTransitionCoordinatorContext!) -> Void in
                    self.shadowView.alpha = 0.0
            }, completion:nil)
        } else {
            shadowView.alpha = 0.0
        }
    }
    
    public override func containerViewWillLayoutSubviews() {
        shadowView.frame = containerView!.bounds
        presentedView!.frame = self.frameOfPresentedViewInContainerView
    }
    
    public override var shouldPresentInFullscreen: Bool {
        return true
    }
    
    public override var adaptivePresentationStyle: UIModalPresentationStyle {
        return .fullScreen
    }
}
