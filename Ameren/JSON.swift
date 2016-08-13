//
//  JSON.swift
//  Ameren
//
//  Created by David Giovannini on 8/12/16.
//  Copyright © 2016 Software by Jove. All rights reserved.
//

import Foundation

// Apple's JSON Map
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
