//
//  ClientsDataSource.swift
//  chargeOclock
//
//  Created by Goran Blažič on 08/01/2017.
//  Copyright © 2017 goranche.net. All rights reserved.
//

import UIKit

class ClientsDataSource: NSObject, UITableViewDataSource {

	let clients: [Client]
	let reuseIdentifier: String

	init(with clients: [Client] = [], reuseIdentifier: String = "devClientCell") {
		self.clients = clients
		self.reuseIdentifier = reuseIdentifier
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return clients.count > 0 ? 1 : 0
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return clients.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
		if var clientCell = cell as? ClientSettable {
			clientCell.client = clients[indexPath.row]
		}
		return cell
	}

}
