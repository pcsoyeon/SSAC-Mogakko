//
//  Sesac.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/30.
//

import UIKit

@frozen
enum Sesac {
    case plain
    case strong
    case mint
    case purple
    case gold
    
    var title: String {
        switch self {
        case .plain:
            return "기본 새싹"
        case .strong:
            return "튼튼 새싹"
        case .mint:
            return "민트 새싹"
        case .purple:
            return "퍼플 새싹"
        case .gold:
            return "골드 새싹"
        }
    }
    
    var description: String {
        switch self {
        case .plain:
            return "새싹을 대표하는 기본 식물입니다. 다른 새싹들과 함께 하는 것을 좋아합니다."
        case .strong:
            return "잎이 하나 더 자라나고 튼튼해진 새나라의 새싹으로 같이 있으면 즐거워집니다."
        case .mint:
            return "호불호의 대명사! 상쾌한 향이 나서 허브가 대중화된 지역에서 많이 자랍니다."
        case .purple:
            return "감정을 편안하게 쉬도록 하며 슬프고 우울한 감정을 진정시켜주는 멋진 새싹입니다."
        case .gold:
            return "화려하고 멋있는 삶을 살며 돈과 인생을 플렉스 하는 자유분방한 새싹입니다."
        }
    }
    
    // TODO: - 값으로 관리 
    var image: UIImage {
        switch self {
        case .plain:
            return Constant.Image.sesacFace1!
        case .strong:
            return Constant.Image.sesacFace2!
        case .mint:
            return Constant.Image.sesacFace3!
        case .purple:
            return Constant.Image.sesacFace4!
        case .gold:
            return Constant.Image.sesacFace5!
        }
    }
    
    var price: Int {
        switch self {
        case .plain:
            return 0
        case .strong:
            return 1200
        case .mint, .purple, .gold:
            return 2500
        }
    }
}
