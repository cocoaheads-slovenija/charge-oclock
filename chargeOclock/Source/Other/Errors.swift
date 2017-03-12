//
//  Errors.swift
//  chargeOclock
//
//  Created by Goran Blažič on 08/01/2017.
//  Copyright © 2017 CocoaHeads Slovenia. All rights reserved.
//

import Foundation

enum oClockError: Error {
	case unknown
	case internalError
	case serverError(code: Int)
	case invalidData
	case unauthorized
	case forbidden
	case notFound

	var localizedDescription: String {
		switch self {
		case .unknown:
			return "Unknown error occoured."
		case .internalError:
			return "Internal error occoured."
		case .serverError(code: let code):
			return "Server error occoured, code \(code)"
		case .invalidData:
			return "Invalid data error occoured."
		case .unauthorized:
			return "Unathorized error occoured."
		case .forbidden:
			return "Forbiden error occoured."
		case .notFound:
			return "Not found error occoured."

		}
	}
}
