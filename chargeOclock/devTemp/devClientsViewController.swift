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

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.dataSource = dataSource

		tableView.refreshControl = UIRefreshControl()
		tableView.refreshControl?.addTarget(self, action: #selector(refresh(refreshControl:)), for: .valueChanged)

		let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusTapped))
		navigationItem.setRightBarButton(plusButton, animated: true)

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

	func plusTapped() {
		let alert = UIAlertController(title: "Add Client", message: "Please, enter client name", preferredStyle: .alert)
		alert.addTextField { textField in
			textField.placeholder = "Client name"
		}
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))

		let createAction = UIAlertAction(title: "Create", style: .default) { (_) in
			guard let name = alert.textFields?.first?.text else {
				return
			}
			let client = Client(name: name)
			client.save() { error, data in
				guard error == nil else {
					print("\(error?.localizedDescription)")
					return
				}
				self.refresh(refreshControl: self.tableView.refreshControl ?? UIRefreshControl() )
			}
		}
		alert.addAction(createAction)
		self.present(alert, animated: true, completion: nil)
	}

}
