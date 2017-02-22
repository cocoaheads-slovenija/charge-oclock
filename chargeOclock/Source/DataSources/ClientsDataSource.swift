//
//  ClientsDataSource.swift
//  chargeOclock
//
//  Created by Goran Blažič on 08/01/2017.
//  Copyright © 2017 CocoaHeads Slovenia. All rights reserved.
//

import UIKit

class ClientsDataSource: NSObject, UITableViewDataSource {

	private(set) var clients: [Client]
	var updateClient: ((Client) -> Void)?
	let reuseIdentifier: String

	init(with clients: [Client] = [], reuseIdentifier: String = "devClientCell") {
		self.clients = clients
		self.reuseIdentifier = reuseIdentifier
	}

	func reload(_ clients: [Client]) {
		self.clients = clients
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return clients.count > 0 ? 1 : 0
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return clients.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ClientTableViewCell
		cell.client = clients[indexPath.row]
		cell.updateClient = updateClient
		return cell
	}

	func removeClient(at index: Int) {
		clients.remove(at: index)
	}

}
