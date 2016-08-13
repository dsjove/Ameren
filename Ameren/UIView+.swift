//
//  UIView+.swift
//  Ameren
//
//  Created by David Giovannini on 8/12/16.
//  Copyright © 2016 Software by Jove. All rights reserved.
//

import UIKit

extension UIView {
	@IBInspectable
	var roundedCorner: CGFloat {
		get {
			return self.layer.cornerRadius
		}
		set {
			self.layer.cornerRadius = newValue
			self.layer.setNeedsDisplay()
		}
	}
	
	@IBInspectable
	var borderWidth: CGFloat {
		get {
			return self.layer.borderWidth
		}
		set {
			self.layer.borderWidth = newValue
			self.layer.setNeedsDisplay()
		}
	}
	
}
