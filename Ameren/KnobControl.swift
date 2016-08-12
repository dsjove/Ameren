//
//  KnobControl.swift
//  Ameren
//
//  Created by David Giovannini on 8/8/16.
//  Copyright © 2016 Object Computing Inc. All rights reserved.
//

import UIKit

@IBDesignable
public class KnobControl : UIControl, UIGestureRecognizerDelegate {
	
	private var panRecognizer: UIPanGestureRecognizer!
	
	@IBInspectable
	public var normalizedValue: CGFloat = 0.0 {
		didSet {
			self.setNeedsDisplay()
		}
	}
	
	@IBInspectable
	public var velocityFactor: CGFloat = 10000.0
	
	@IBInspectable
	public var symbol: UIImage? = nil {
		didSet {
			self.setNeedsDisplay()
		}
	}
	
	@IBInspectable
	public var minValue: CGFloat  = 0.0 {
		didSet {
			self.setNeedsDisplay()
		}
	}
	
	@IBInspectable
	public var maxValue: CGFloat  = 1.0 {
		didSet {
			self.setNeedsDisplay()
		}
	}

	public var value: CGFloat {
		set {
			normalizedValue = newValue - self.minValue / (self.maxValue-self.minValue)
		}
		get {
			return self.minValue + (self.maxValue-self.minValue) * normalizedValue
		}
	}
	
	private func applyVelocity(velocity: CGFloat) {
		let d = velocity / velocityFactor
		let m = max(min(normalizedValue + d, 1.0), 0.0)
		normalizedValue = m
		self.sendActions(for: .valueChanged) // only on user interactions
	}
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.setup()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setup()
	}
	
	private func setup() {
		self.clipsToBounds = false
		panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned))
		self.addGestureRecognizer(panRecognizer)
	}
	
	@objc private func panned(_ pgr: UIPanGestureRecognizer) {
		if pgr.state == .changed || pgr.state == .ended {
			let vp = pgr.velocity(in: self)
			self.applyVelocity(velocity: vp.x)
		}
	}
	
	public override func draw(_ rect: CGRect) {
		let context = UIGraphicsGetCurrentContext()!
		context.setStrokeColor(self.tintColor.cgColor)
		context.setFillColor(self.tintColor.cgColor)
	
		let thickness: CGFloat = 3.0
		let b = self.bounds
		let r = b.insetBy(dx: thickness/2.0, dy: thickness/2.0)
		
		var k = r
		k.size.width = min(r.size.width, r.size.height)
		k.size.height = k.size.width
		
		do {
			context.setLineWidth(thickness)
			context.strokeEllipse(in: k)
		}
		do {
			if let image = symbol {
				let symbolRect = k.insetBy(dx: thickness * 3.5, dy: thickness * 3.5)
				image.draw(in: symbolRect)
			}
		}
		do {
			context.setLineWidth(1.0)
			let inner = k.insetBy(dx: thickness*2.5, dy: thickness*2.5)
			context.strokeEllipse(in: inner)
			var x = k.midX
			if normalizedValue == 0.0 {
				x -= (thickness/2.0 + 2)
			}
			else if normalizedValue == 1.0 {
				x += (thickness/2.0 + 2)
			}
			context.moveTo(x: x, y: k.minY+thickness)
			context.addLineTo(x: x, y: k.minY+thickness*3.5)
			context.strokePath()
		}
		do {
			let radians = CGFloat(M_PI * 2.0) * normalizedValue
			var t = CGAffineTransform.identity
			t = t.translatedBy(x: k.midX, y: k.midY)
			t = t.rotated(by: CGFloat(radians))
			t = t.translatedBy(x: -k.midX, y: -k.midY)
			context.concatenate(t)
			let tick = CGRect(x: k.midX-thickness, y: k.minY+thickness*1.5, width: thickness*2.0, height: thickness*2.0)
			context.fillEllipse(in: tick)
		}
	}
}
