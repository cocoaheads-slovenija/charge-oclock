//
//  ClientsTableViewDelegate.swift
//  chargeOclock
//
//  Created by Adel Burekovic on 18/01/2017.
//  Copyright © 2017 CocoaHeads Slovenia. All rights reserved.
//

import UIKit

class ClientsTableViewDelegate: NSObject, UITableViewDelegate {

	var deleteClient: ((IndexPath) -> Void)?
	var updateClient: ((IndexPath) -> Void)?

	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		return [UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
			self.deleteClient?(indexPath)
		}]
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		self.updateClient?(indexPath)
	}
}
