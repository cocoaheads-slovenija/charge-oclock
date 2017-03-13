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

	var id: Int? = nil
	var isDirty: Bool

	var name: String = "" {
		didSet {
			isDirty = oldValue != name
		}
	}

	init(name: String) {
		self.name = name
		self.isDirty = true
	}

	init(from json: [String: Any]) {
		self.id = json["id"] as? Int
		self.name = json["name"] as? String ?? ""
		self.isDirty = false
	}

	func toJSON() -> [String: Any] {
		var json: [String: Any] = ["name": name]
		if let id = id {
			json["id"] = id
		}
		return json
	}

	func delete(completion: @escaping (Error?) -> Void) {
		NetworkAPI.shared.delete(client: self) { data, error in
			completion(error)
		}
	}

	func save(completion: @escaping (Error?) -> Void) {
		guard isDirty else {
			return
		}
		if id == nil {
			NetworkAPI.shared.create(client: self) { data, error in
				guard error == nil else {
					completion(error)
					return
				}
				guard let data = data else {
					completion(oClockError.invalidData)
					return
				}
				do {
					guard let client = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
						completion(oClockError.invalidData)
						return
					}
					self.id = client["id"] as? Int
					self.isDirty = false
					completion(nil)
				} catch let error {
					completion(error)
				}
			}
		} else {
			NetworkAPI.shared.update(client: self) { data, error in
				guard error == nil else {
					completion(error)
					return
				}
				self.isDirty = false
				completion(nil)
			}
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
