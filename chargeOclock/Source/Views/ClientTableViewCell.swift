//
//  ClientTableViewCell.swift
//  chargeOclock
//
//  Created by Goran Blažič on 08/01/2017.
//  Copyright © 2017 CocoaHeads Slovenia. All rights reserved.
//

import UIKit

class ClientTableViewCell: UITableViewCell, ClientSettable {

	var client: Client? = nil {
		didSet {
			textLabel?.text = client?.name
			detailTextLabel?.text = "\(client?.id ?? 0)"
		}
	}

	override func prepareForReuse() {
		textLabel?.text = ""
		detailTextLabel?.text = ""
	}

}
