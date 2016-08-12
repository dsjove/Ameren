//
//  DetailViewController.swift
//  Ameren
//
//  Created by David Giovannini on 8/8/16.
//  Copyright © 2016 Object Computing Inc. All rights reserved.
//

import UIKit

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
	
	@IBAction func infoButtonWasTapped(sender: UIButton) {
        self.transitioningDelegate = TransitionDelegate
        let vc = self.storyboard!.instantiateViewController(withIdentifier: String(InteractionViewController.self))
		vc.modalPresentationStyle = .custom
		vc.transitioningDelegate = TransitionDelegate
        present(vc, animated: true, completion: nil)
    }
}

