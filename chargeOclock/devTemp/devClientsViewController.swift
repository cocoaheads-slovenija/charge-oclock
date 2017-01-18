//
//  devClientsViewController.swift
//  chargeOclock
//
//  Created by Goran Blažič on 08/01/2017.
//  Copyright © 2017 CocoaHeads Slovenia. All rights reserved.
//

import UIKit

class devClientsViewController: UITableViewController {

	private var dataSource = ClientsDataSource()
	private var tableViewDelegate = ClientsTableViewDelegate()

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.dataSource = dataSource
		tableView.delegate = tableViewDelegate
		tableViewDelegate.deleteClient = deleteClient
		tableView.refreshControl = UIRefreshControl()
		tableView.refreshControl?.addTarget(self, action: #selector(refresh(refreshControl:)), for: .valueChanged)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		refresh(refreshControl: tableView.refreshControl ?? UIRefreshControl())
	}

	@objc private func refresh(refreshControl: UIRefreshControl) {
		refreshControl.beginRefreshing()

		Client.all { clients, error in

			// TODO: Handle errors in a more meaningfull way 😅
			if let error = error {
				print("💥 \(error)")
			}

			self.dataSource = ClientsDataSource(with: clients)
			self.tableView.dataSource = self.dataSource
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}

			refreshControl.endRefreshing()
		}
	}

	func deleteClient(at indexPath: IndexPath) {
		dataSource.clients[indexPath.row].delete { error in

			if let error = error {
				let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
				DispatchQueue.main.async {
					self.present(alert, animated: true, completion: nil)
				}
				return
			}

			self.dataSource.removeClient(at: indexPath.row)
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
}
