//
//  UIView+Extension.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/07.
//

import UIKit

extension UIView {
    public func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
    
    public func makeRound(radius: CGFloat = 10) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}

