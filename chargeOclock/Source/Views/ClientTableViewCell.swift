//
//  ClientTableViewCell.swift
//  chargeOclock
//
//  Created by Goran Blažič on 08/01/2017.
//  Copyright © 2017 CocoaHeads Slovenia. All rights reserved.
//

import UIKit

class ClientTableViewCell: UITableViewCell, ClientSettable {

	@IBOutlet private var nameTextField: UITextField!
	@IBOutlet private var detailLabel: UILabel!

	private var clientTextFieldDelegate = ClientTextFieldDelegate()

	var updateClient: ((Client) -> Void)?

	var client: Client? = nil {
		didSet {
			nameTextField.text = client?.name
			detailLabel.text = "\(client?.id ?? 0)"
			nameTextField.delegate = clientTextFieldDelegate
			clientTextFieldDelegate.endEditingWithText = handleNewClientName
		}
	}

	override func prepareForReuse() {
		nameTextField.text = ""
		detailLabel.text = ""
	}

	func handleNewClientName(name: String) {
		client?.name = name
		guard let client = client else {
			return
		}
		updateClient?(client)
	}
}
