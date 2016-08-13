//
//  MyModel.swift
//  Ameren
//
//  Created by David Giovannini on 8/9/16.
//  Copyright © 2016 Object Computing Inc. All rights reserved.
//

import Foundation
import CoreLocation

// https://github.com/ashleymills/Reachability.swift

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
public protocol MyModelDelegate: class, GeoService {
	func save(mode: MyModel, completion: (()->())?)
}

extension MyModelDelegate {
	public func fetchAddress(location: CLLocationCoordinate2D, completion: (ServiceResult<Address>)->()) {
		completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
	}
	public func save(mode: MyModel, completion: (()->())?) {
		completion?()
	}
	
	public func doSomething() { // not polymorphic
	}
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
	
	deinit {
		// last ref is nil
	}
	
	public func save(completion: (() -> ())? = nil) {
		if let delegate = delegate {
			delegate.save(mode: self, completion: completion)
		}
		else {
			completion?()
		}
	}
	
	public convenience init?() throws {
		let dfts = UserDefaults()
		let value = dfts.value(forKey: "memento")
		if let value = value as? JSONDictionary {
			try self.init(memento: value)
			return
		}
		return nil
		
/*
		let dfts = UserDefaults()
		dfts.set(self.memento, forKey: "memento")
		dfts.synchronize()
	*/
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
	
	public func update(completion: (MyModel)->()) -> Void {
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
