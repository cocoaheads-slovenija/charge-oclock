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

	func delete(client: Client, completion: @escaping NetworkCompletion) {
		performDeleteRequest(to: "clients/\(client.id)", completion: completion)
	}

	func create(client: Client, completion: @escaping NetworkCompletion) {
		do {
			let data = try JSONSerialization.data(withJSONObject: client.toJSON(), options: [])
			performPostRequest(to: "clients", data: data, completion: completion)
		} catch {
			completion(nil, oClockError.invalidData)
		}
	}

	func update(client: Client, completion: @escaping NetworkCompletion) {
		do {
			let data = try JSONSerialization.data(withJSONObject: client.toJSON(), options: [])
			performPatchRequest(to: "clients/\(client.id)", data: data, completion: completion)
		} catch {
			completion(nil, oClockError.invalidData)
		}
	}
}

class NetworkAPI {

	typealias NetworkCompletion = (Data?, Error?) -> Void

	static let shared = NetworkAPI()

	// Mind the trailing slash, as this is used as a baseURL
	// yes, explicit unwrapping, if we fail here, it might as well be the end of the world!
	let baseURL = URL(string: "https://clocker.goranche.net/")!

	// For development, you might want to use your local server
	//	let baseURL = URL(string: "http://localhost:8080/")!

	// MARK: - Helper functions

	private init() {
	}

	fileprivate func performPostRequest(to uri: String, data: Data, completion: @escaping NetworkCompletion) {
		performRequest(to: uri, method: "POST", headers: ["Content-Type" : "application/json; charset=utf-8"], data: data, completion: completion)
	}

	fileprivate func performPatchRequest(to uri: String, data: Data, completion: @escaping NetworkCompletion) {
		performRequest(to: uri, method: "PATCH", headers: ["Content-Type" : "application/json; charset=utf-8"], data: data, completion: completion)
	}

	fileprivate func performGetRequest(to uri: String, completion: @escaping NetworkCompletion) {
		performRequest(to: uri, method: "GET", completion: completion)
	}

	fileprivate func performDeleteRequest(to uri: String, completion: @escaping NetworkCompletion) {
		performRequest(to: uri, method: "DELETE", completion: completion)
	}

	private func performRequest(to uri: String, method httpMethod: String, headers: [String : String]? = nil, data: Data? = nil, completion: @escaping NetworkCompletion) {
		guard let url = constructURL(for: uri, completion: completion) else {
			return
		}

		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = httpMethod
		urlRequest.httpBody = data

		if let header = headers {
			for (key, value) in header {
				urlRequest.addValue(value, forHTTPHeaderField: key)
			}
		}

		URLSession.shared.dataTask(with: urlRequest) { data, response, error in
			guard !self.isError(error, completion: completion) else {
				return
			}
			guard let response = response as? HTTPURLResponse, self.checkResponseCode(response.statusCode, completion: completion) else {
				return
			}
			guard let data = data else {
				completion(nil, oClockError.serverError(code: response.statusCode))
				return
			}
			completion(data, nil)
		}.resume()
	}

	private func constructURL(for uri: String, completion: NetworkCompletion) -> URL? {
		guard let url = URL(string: uri, relativeTo: baseURL) else {
			completion(nil, oClockError.internalError)
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
			var error = oClockError.unknown
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
