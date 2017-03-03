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

	var client: Client? = nil {
		didSet {
			nameTextField.text = client?.name
			detailLabel.text = "\(client?.id ?? 0)"
			nameTextField.delegate = self
		}
	}

	override func prepareForReuse() {
		nameTextField.text = ""
		detailLabel.text = ""
	}
}

extension ClientTableViewCell: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
		guard let text = textField.text, let client = client else {
			return
		}
		client.name = text
		client.save { error in
			guard error == nil else {
				let alert = UIAlertController(title: "Save error", message: "Client saving failed, error \(error?.localizedDescription)", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil ))

				var parentViewController: UIViewController? {
					var parentResponder: UIResponder? = self
					while parentResponder != nil {
						parentResponder = parentResponder!.next
						if parentResponder is UIViewController {
							return parentResponder as! UIViewController!
						}
					}
					return nil
				}

				parentViewController?.present(alert, animated: true, completion: nil)
				return
			}
		}
	}
}
