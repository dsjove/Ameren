//
//  Locations.swift
//  Ameren
//
//  Created by David Giovannini on 8/12/16.
//  Copyright © 2016 Software by Jove. All rights reserved.
//

import Foundation

public enum Locations: String, CustomStringConvertible {
	case desk
	case kitchen
	
	public var description: String {
		return NSLocalizedString(self.rawValue, comment: "nothing")
	}
}

var l = [Locations.desk, Locations.kitchen]
