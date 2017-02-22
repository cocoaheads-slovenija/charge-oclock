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
		dataSource.updateClient = updateClient
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

			self.dataSource.reload(clients)
			self.tableView.dataSource = self.dataSource
			DispatchQueue.main.async {
				self.tableView.reloadData()
				refreshControl.endRefreshing()
			}
		}
	}

	@IBAction func plusTapped(sender: AnyObject) {
		let alert = UIAlertController(title: "Add Client", message: "Please, enter client name", preferredStyle: .alert)
		alert.addTextField { textField in
			textField.placeholder = "Client name"
		}
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
		alert.addAction(UIAlertAction(title: "Create", style: .default) { _ in
			guard let name = alert.textFields?.first?.text, !name.isEmpty else {
				let nameEmptyAlert = UIAlertController(title: "Ups", message: "Looks like you forgot to enter the username. Please, try again.", preferredStyle: .alert)
				nameEmptyAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
				self.present(nameEmptyAlert, animated: true, completion: nil)
				return
			}
			let client = Client(name: name)
			client.save() { error in
				guard error == nil else {
					print("\(error?.localizedDescription)")
					return
				}
				self.refresh(refreshControl: self.tableView.refreshControl ?? UIRefreshControl() )
			}
		})
		self.present(alert, animated: true, completion: nil)
	}

	func deleteClient(at indexPath: IndexPath) {
		dataSource.clients[indexPath.row].delete { error in

			if let error = error {
				let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
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

	func updateClient(client: Client) {
		client.save() { error in
			if let error = error {
				let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
				DispatchQueue.main.async {
					self.present(alert, animated: true, completion: nil)
				}
				return
			}
			self.refresh(refreshControl: self.tableView.refreshControl ?? UIRefreshControl())
		}
	}
}
