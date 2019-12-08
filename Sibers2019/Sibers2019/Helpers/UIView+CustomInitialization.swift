//
// Created by Igor Djachenko on 2019-05-19.
// Copyright (c) 2019 Igor Djachenko. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    class func bySelfNib() -> Self? {
        return by(nibName: String(describing: self))
    }

    class func by<T>(nibName: String) -> T? {
        return UINib(nibName: nibName, bundle: nil).instantiate(withOwner: nil).first as? T
    }
}