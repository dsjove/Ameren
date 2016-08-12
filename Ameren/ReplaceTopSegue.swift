//
//  ReplaceTopSegue.swift
//  Ameren
//
//  Created by David Giovannini on 8/9/16.
//  Copyright © 2016 Software by Jove. All rights reserved.
//

import UIKit

// Use custom UIStoryboardSegue if you are already using
// segues and the standard segues do not give you the 
// exact view controller containment you need.
public class ReplaceTopSegue: UIStoryboardSegue {
    public override func perform() {
		if let nav = source.navigationController {
			var vcs = nav.viewControllers
			let idx = vcs.index(of: self.source)!
			vcs = Array(vcs[vcs.startIndex...idx])
			vcs[idx] = self.destination
			nav.setViewControllers(vcs, animated: false)
		}
    }
}
