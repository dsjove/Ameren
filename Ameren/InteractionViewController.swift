//
//  InteractionViewController.swift
//  Ameren
//
//  Created by David Giovannini on 8/9/16.
//  Copyright © 2016 Object Computing Inc. All rights reserved.
//

import UIKit
import CoreLocation

class InteractionViewController: UIViewController, CLLocationManagerDelegate {

	@IBOutlet weak var valueLabel: UILabel!
	@IBOutlet weak var addressLabel: UILabel!
	
	private var model: MyModel!
	let locationManager = CLLocationManager()
	let geoService = AppleService()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		locationManager.requestWhenInUseAuthorization()
		
		if CLLocationManager.locationServicesEnabled() {
			locationManager.delegate = self
			locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
			locationManager.startUpdatingLocation()
			if let userLocation = locationManager.location {
				model = MyModel(location: userLocation.coordinate)
				model.delegate = geoService
			}
		}
    }
	
	public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let userLocation = locations.first {
			model = MyModel(location: userLocation.coordinate)
			model.delegate = geoService
		}
	}
	
	public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		locationManager.startUpdatingLocation()
    }
	
	@IBAction func controlChange(sender: AnyObject!) {
		let control = sender as! KnobControl
		valueLabel.text = String(format: "%.2f", control.value) ?? "0.0"
	}
	
	@IBAction func doLocation(sender: AnyObject!) {
		self.model.update() { [weak self] model in
			self?.addressLabel.text = model.address?.street ?? "None"
		}
	}
}
