//
// Created by Igor Djachenko on 2019-05-19.
// Copyright (c) 2019 Igor Djachenko. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    //this property may never be accessed but yet required:
    //we need view controller to keep controller alive because iOS keeps stack on VC level
    var controller: BaseController?

    func handle(error message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default)

        alert.addAction(okAction)

        present(alert, animated: true)
    }
}
