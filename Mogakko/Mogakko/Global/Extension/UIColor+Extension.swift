//
//  UIColor+Extension.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/07.
//

import UIKit

extension UIColor {
    
    // MARK: - Black & White
    
    @nonobjc class var white: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var black: UIColor {
        return UIColor(red: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
    }
    
    // MARK: - Brand Color
    
    @nonobjc class var green: UIColor {
        return UIColor(red: 73.0 / 255.0, green: 220.0 / 255.0, blue: 146.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var whiteGreen: UIColor {
        return UIColor(red: 205.0 / 255.0, green: 244.0 / 255.0, blue: 225.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var yellowGreen: UIColor {
        return UIColor(red: 178.0 / 255.0, green: 235.0 / 255.0, blue: 97.0 / 255.0, alpha: 1.0)
    }
    
    // MARK: - Gray Scale
    
    @nonobjc class var gray1: UIColor {
        return UIColor(red: 247.0 / 255.0, green: 247.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var gray2: UIColor {
        return UIColor(red: 239.0 / 255.0, green: 239.0 / 255.0, blue: 239.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var gray3: UIColor {
        return UIColor(red: 226.0 / 255.0, green: 226.0 / 255.0, blue: 226.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var gray4: UIColor {
        return UIColor(red: 209.0 / 255.0, green: 209.0 / 255.0, blue: 209.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var gray5: UIColor {
        return UIColor(red: 189.0 / 255.0, green: 189.0 / 255.0, blue: 189.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var gray6: UIColor {
        return UIColor(red: 170.0 / 255.0, green: 170.0 / 255.0, blue: 170.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var gray7: UIColor {
        return UIColor(red: 136.0 / 255.0, green: 136.0 / 255.0, blue: 136.0 / 255.0, alpha: 1.0)
    }
    
    // MARK: - System Color
    
    @nonobjc class var success: UIColor {
        return UIColor(red: 98.0 / 255.0, green: 143.0 / 255.0, blue: 229.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var error: UIColor {
        return UIColor(red: 233.0 / 255.0, green: 102.0 / 255.0, blue: 107.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var focus: UIColor {
        return UIColor(red: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
    }
}
