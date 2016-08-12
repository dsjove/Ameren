//
//  GeoService.swift
//  Ameren
//
//  Created by David Giovannini on 8/9/16.
//  Copyright © 2016 Software by Jove. All rights reserved.
//

import Foundation
import CoreLocation

// Apple's JSON representation
public typealias JSONDictionary = [NSObject : AnyObject]

// Simple Helper for JSON parsing
func cast<T>(_ element: AnyObject?) throws -> T {
	if let element = element as? T {
		return element
	}
	throw NSError(domain: "", code: 0, userInfo:  nil)
}

func cast<T>(_ element: AnyObject?, dft: T?) throws -> T? {
	if element == nil || element is NSNull {
		return dft
	}
	if let element = element as? T {
		return element
	}
	throw NSError(domain: "", code: 0, userInfo:  nil)
}

public enum ServiceResult<T> {
	case success(T)
	case failure(NSError)
}

public class FileService: MyModelDelegate {
	public func fetchPlacment(location: CLLocationCoordinate2D, completion: (ServiceResult<Address>)->()) {
		completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
	}
}

public class AppleService: MyModelDelegate {
	public func fetchPlacment(location: CLLocationCoordinate2D, completion: (ServiceResult<Address>)->()) {
		let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
		CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
			if let error = error {
				completion(.failure(error))
			}
			else if let address = placemarks?.first?.addressDictionary {
				do {
					try completion(.success(Address(memento: address)))
				}
				catch let e as NSError {
					completion(.failure(e))
				}
			}
			else {
				completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
			}
		})
	}
}

public class GoogleService: MyModelDelegate {
	public func fetchPlacment(location: CLLocationCoordinate2D, completion: (ServiceResult<Address>)->()) {
		let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
		let apikey = "AIzaSyDD2cdvsUovQ8lxtxSHzwxVuPlsmfa1Amo"
	    let url = URL(string: "\(baseUrl)latlng=\(location.latitude),\(location.longitude)&key=\(apikey)")
		DispatchQueue.global().async {
			var result: ServiceResult<Address>!
			do {
				let data = try Data(contentsOf: url!)
				let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
				if let results = json["results"] as? NSArray {
					if let addressFields = results[0]["address_components"] as? NSArray {
						let address: JSONDictionary = [
							"Street": addressFields[0]["long_name"] as! String,
							"City": addressFields[1]["long_name"] as! String,
							"State": addressFields[3]["long_name"] as! String,
							"Country": addressFields[4]["long_name"] as! String,
							"ZIP": addressFields[5]["long_name"] as! String,
						]
						result = try .success(Address(memento: address))
					}
				}
				if result == nil {
					result = .failure(NSError(domain: "", code: 0, userInfo: nil))
				}
			}
			catch let e as NSError {
				result = .failure(e)
			}
			DispatchQueue.main.async {
				completion(result)
			}
		}
	}
}
