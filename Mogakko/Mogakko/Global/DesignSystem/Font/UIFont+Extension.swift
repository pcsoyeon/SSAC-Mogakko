//
//  UIFont+Extension.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/07.
//

import UIKit

extension UIFont {
    enum FontType: String {
        case medium = "NotoSansCJKkr-Medium"
        case regular = "NotoSansCJKkr-Regular"
        
        var name: String {
            return self.rawValue
        }
        
        static func font(_ type: FontType, ofsize size: CGFloat) -> UIFont {
            return UIFont(name: type.rawValue, size: size)!
        }
    }
}
