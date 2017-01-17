//
//  Client.swift
//  chargeOclock
//
//  Created by Goran Blažič on 08/01/2017.
//  Copyright © 2017 CocoaHeads Slovenia. All rights reserved.
//

import Foundation

protocol ClientSettable {
	var client: Client? { get set }
}

class Client {

	var id: Int = 0
	var name: String = ""

	init(id: Int, name: String) {
		self.id = id
		self.name = name
	}

	init(from json: [String: Any]) {
		self.id = json["id"] as? Int ?? 0
		self.name = json["name"] as? String ?? ""
	}

	func delete(completion: @escaping (Error?) -> Void) {
		NetworkAPI.shared.delete(client: self) { data, error in
			completion(error)
		}
	}
}

extension Client {

	static func all(completion: @escaping ([Client], Error?) -> Void) {
		NetworkAPI.shared.listClients { data, error in
			if let error = error {
				completion([], error)
			} else if let data = data {
				do {
					guard let clientsArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]] else {
						completion([], oClockError.invalidData)
						return
					}
					completion(clientsArray.filter {
						return $0["id"] as? Int != nil && $0["name"] as? String != nil
						}.map { Client(from: $0) }, nil)
				} catch {
					completion([], oClockError.invalidData)
				}
			}
		}
	}
}
