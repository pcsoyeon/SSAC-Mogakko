//
//  UIView+Extension.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/07.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
    
    func makeRound(radius: CGFloat = 8) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}

