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
		Client.addClient(name: "Test name") { error, data in
			if error != nil {
				print("Error")
			} else if data != nil {
				print("\(data)")
			}
		}
	}

}
