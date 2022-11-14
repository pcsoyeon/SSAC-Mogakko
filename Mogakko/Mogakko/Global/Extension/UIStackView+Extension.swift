//
//  UIStackView+Extension.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/14.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach {
            addArrangedSubview($0)
        }
    }
}
