//
//  Errors.swift
//  chargeOclock
//
//  Created by Goran Blažič on 08/01/2017.
//  Copyright © 2017 goranche.net. All rights reserved.
//

import Foundation

enum oClockErrors: Error {
	case unknown
	case internalError
	case serverError(code: Int)
	case invalidData
	case unauthorized
	case forbidden
	case notFound
}
