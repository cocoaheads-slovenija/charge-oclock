//
//  ClientTextFieldDelegate.swift
//  chargeOclock
//
//  Created by Andrej Krizmancic on 20/02/2017.
//  Copyright © 2017 CocoaHeads Slovenia. All rights reserved.
//

import UIKit

class ClientTextFieldDelegate: NSObject, UITextFieldDelegate {

	var endEditingWithText: ((String) -> Void)?

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
		guard let text = textField.text else {
			return
		}
		self.endEditingWithText?(text)
	}
}
