//
//  MDSFont.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/07.
//

import UIKit

struct FontProperty {
    let font: UIFont.FontType
    let size: CGFloat
    let lineHeight: CGFloat?
}

enum MDSFont {
    case Display1_R20
    
    case Title1_M16
    case Title2_R16
    case Title3_M14
    case Title4_R14
    case Title5_M12
    case Title6_R12
    
    case Body1_M16
    case Body2_R16
    case Body3_R14
    case Body4_R12
    case caption_R10
    
    public var fontProperty: FontProperty {
        switch self {
        case .Display1_R20:
            return FontProperty(font: .regular, size: 20, lineHeight: 32)
        case .Title1_M16:
            return FontProperty(font: .medium, size: 16, lineHeight: 25.6)
        case .Title2_R16:
            return FontProperty(font: .regular, size: 16, lineHeight: 25.6)
        case .Title3_M14:
            return FontProperty(font: .medium, size: 14, lineHeight: 22.4)
        case .Title4_R14:
            return FontProperty(font: .regular, size: 14, lineHeight: 22.4)
        case .Title5_M12:
            return FontProperty(font: .medium, size: 12, lineHeight: 18)
        case .Title6_R12:
            return FontProperty(font: .regular, size: 12, lineHeight: 18)
        case .Body1_M16:
            return FontProperty(font: .medium, size: 16, lineHeight: 29.6)
        case .Body2_R16:
            return FontProperty(font: .regular, size: 16, lineHeight: 29.6)
        case .Body3_R14:
            return FontProperty(font: .medium, size: 14, lineHeight: 23.8)
        case .Body4_R12:
            return FontProperty(font: .regular, size: 12, lineHeight: 21.6)
        case .caption_R10:
            return FontProperty(font: .regular, size: 10, lineHeight: 16)
        }
    }
}

extension MDSFont {
    var font: UIFont {
        guard let font = UIFont(name: fontProperty.font.name, size: fontProperty.size) else {
            return UIFont()
        }
        return font
    }
}
