//
//  MyModel.swift
//  Ameren
//
//  Created by David Giovannini on 8/9/16.
//  Copyright © 2016 Object Computing Inc. All rights reserved.
//

import Foundation
import CoreLocation

// struct or final allows the optimizer to consider inline optimizations
final public class Address {
// prefer immutable state
	public let street: String
	public let city: String
	public let zip: String
	public let state: String
	public let country: String
// RAII construction
// throws is a failable constructor that exposes cause
	public init(memento: JSONDictionary) throws {
		street = try cast(memento["Street"])
		city = try cast(memento["City"])
		zip = try cast(memento["ZIP"])
		state = try cast(memento["State"])
		country = try cast(memento["Country"])
	}
	
	public var memento: JSONDictionary {
		return [
			"Street": street,
			"City": city,
			"State": state,
			"Country": country,
			"ZIP": zip,
		]
	}
}

// Easily mock/swap the extenal dependency for MyModel
public protocol MyModelDelegate: class {
	func fetchPlacment(location: CLLocationCoordinate2D, completion: (ServiceResult<Address>)->())
}

final public class MyModel {
	public let location: CLLocationCoordinate2D
	public private(set) var address: Address?
	
	public weak var delegate: MyModelDelegate?
	
	public init(location: CLLocationCoordinate2D) {
		function(5) // C functions
		let _ = constant // C functions
		self.location = location
	}
	
	public init(memento: JSONDictionary) throws {
		location = CLLocationCoordinate2D(
			latitude: try cast(memento["latitude"]),
			longitude: try cast(memento["longitude"]))
		address = try cast(memento["address"], dft: nil)
	}
	
	public var memento: JSONDictionary {
		return [
			"latitude": location.latitude,
			"longitude": location.longitude,
			"address": address?.memento ?? NSNull()
		]
	}
	
	public func update(completion: (MyModel)->()) {
		if let delegate = delegate {
			delegate.fetchPlacment(location: self.location) { (result) in
				switch result {
					case .success(let value):
						self.address = value
						break
					default:
						break
				}
				completion(self)
			}
		}
		else {
			completion(self) // always call completion blocks
		}
	}
}
