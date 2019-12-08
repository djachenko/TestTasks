//
// Created by Igor Djachenko on 2019-05-19.
// Copyright (c) 2019 Igor Djachenko. All rights reserved.
//

import Foundation
import UIKit

class UIViewFromNib: UIView {
    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        innerInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        innerInit()
    }

    private func innerInit() {
        let nibName = String(describing: type(of: self))

        guard let innerView = Bundle(for: type(of: self)).loadNibNamed(nibName, owner: self)?.first as? UIView else {
            return
        }

        innerView.bounds = self.bounds
        innerView.frame = self.bounds

        isOpaque = innerView.isOpaque
        backgroundColor = .clear

        addSubview(innerView)

        innerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        innerView.translatesAutoresizingMaskIntoConstraints = true
    }
}
