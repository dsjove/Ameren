//
//  DetailViewController.swift
//  Ameren
//
//  Created by David Giovannini on 8/8/16.
//  Copyright © 2016 Object Computing Inc. All rights reserved.
//

import UIKit

extension UIStoryboard {
	public func instantiateViewController<T: UIViewController>(withIdentifier identifier: String = String(T.self)) -> T {
		let vc = self.instantiateViewController(withIdentifier: identifier) as! T
		return vc
	}
}

class DetailViewController: UIViewController {

    let TransitionDelegate = TransitioningDelegate()
	
	@IBOutlet weak var detailDescriptionLabel: UILabel!

	var detailItem: NSDate? {
		didSet {
		    if self.isViewLoaded {
				self.configureView()
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.configureView()
	}
	
	func configureView() {
		detailDescriptionLabel.text = detailItem?.description ?? "None"
	}
	
	@IBAction func modal(sender: AnyObject!) {
		let vc: InteractionViewController = self.storyboard!.instantiateViewController()
		vc.m = 9
        present(vc, animated: true, completion: nil)
	}
	
	@IBAction func infoButtonWasTapped(sender: UIButton) {
        self.transitioningDelegate = TransitionDelegate
        let vc = self.storyboard!.instantiateViewController(withIdentifier: String(InteractionViewController.self))
		vc.modalPresentationStyle = .custom
		vc.transitioningDelegate = TransitionDelegate
        present(vc, animated: true, completion: nil)
    }
}

