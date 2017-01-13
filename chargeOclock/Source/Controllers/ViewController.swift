//
//  ViewController.swift
//  chargeOclock
//
//  Created by Goran Blažič on 08/01/2017.
//  Copyright © 2017 CocoaHeads Slovenia. All rights reserved.
//

import UIKit

#if PRODUCTION
	let environmentString = "production"
#elseif Staging
	let environmentString = "staging"
#elseif Release
	let environmentString = "production"
#else
	let environmentString = "development"
#endif

class ViewController: UIViewController {

	@IBOutlet var environmentLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()

		environmentLabel.text = environmentString;
	}
}
