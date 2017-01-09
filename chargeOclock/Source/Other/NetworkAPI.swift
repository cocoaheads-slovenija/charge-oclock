//
//  NetworkAPI.swift
//  chargeOclock
//
//  Created by Goran Blažič on 08/01/2017.
//  Copyright © 2017 CocoaHeads Slovenia. All rights reserved.
//

import Foundation

extension NetworkAPI {

	// MARK: - Clients

	func listClients(completion: @escaping NetworkCompletion) {
		performGetRequest(to: "clients", completion: completion)
	}

}

class NetworkAPI {

	typealias NetworkCompletion = (Data?, Error?) -> Void

	static let shared = NetworkAPI()

	// Mind the trailing slash, as this is used as a baseURL
	// yes, explicit unwinding, if we fail here, it might as well be the end of the world!
	let baseURL = URL(string: "https://clocker.goranche.net/")!

	// For development, you might want to use your local server
//	let baseURL = URL(string: "http://localhost:8080/")!

	// MARK: - Helper functions

	private init() {
	}

	fileprivate func performGetRequest(to uri: String, completion: @escaping NetworkCompletion) {
		guard let url = constructURL(for: uri, completion: completion) else {
			return
		}
		URLSession.shared.dataTask(with: url) { data, response, error in
			guard !self.isError(error, completion: completion) else {
				return
			}
			guard let response = response as? HTTPURLResponse, self.checkResponseCode(response.statusCode, completion: completion) else {
				return
			}
			guard let data = data else {
				completion(nil, oClockErrors.serverError(code: response.statusCode))
				return
			}
			completion(data, nil)
			}.resume()
	}

	private func constructURL(for uri: String, completion: NetworkCompletion) -> URL? {
		guard let url = URL(string: uri, relativeTo: baseURL) else {
			completion(nil, oClockErrors.internalError)
			return nil
		}
		return url
	}

	private func isError(_ error: Error?, completion: NetworkCompletion) -> Bool {
		guard error == nil else {
			completion(nil, error)
			return true
		}
		return false
	}

	private func checkResponseCode(_ statusCode: Int, completion: NetworkCompletion) -> Bool {
		guard statusCode >= 200, statusCode < 300 else {
			var error = oClockErrors.unknown
			switch statusCode {
			case 401:
				error = .unauthorized
			case 403:
				error = .forbidden
			case 404:
				error = .notFound
			default:
				error = .serverError(code: statusCode)
			}
			completion(nil, error)
			return false
		}
		return true
	}

}
