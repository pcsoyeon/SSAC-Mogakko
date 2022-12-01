//
//  SesacPriceType.swift
//  Mogakko
//
//  Created by 소연 on 2022/12/01.
//

import UIKit

@frozen
enum SesacPriceType {
    case had
    case price1200
    case price2500
    
    var text: String {
        switch self {
        case .had:
            return "보유"
        case .price1200:
            return "1,200"
        case .price2500:
            return "2,500"
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .had:
            return .gray2
        case .price1200, .price2500:
            return .green
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .had:
            return .gray7
        case .price1200, .price2500:
            return .white
        }
    }
}
