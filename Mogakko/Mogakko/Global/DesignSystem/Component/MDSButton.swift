//
//  MDSButton.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/07.
//

import UIKit

// MARK: - Button Type

@frozen
enum MDSButtonType {
    case inactive
    case fill
    case outlint
    case cancel
    case disable
    
    var backgrounColor: UIColor {
        switch self {
        case .inactive, .outlint:
            return .white
        case .fill:
            return .green
        case .cancel:
            return .gray2
        case .disable:
            return .gray6
        }
    }
    
    var boderColor: UIColor {
        switch self {
        case .inactive:
            return .gray4
        case .fill, .outlint:
            return .green
        case .cancel:
            return .gray2
        case .disable:
            return .gray6
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .inactive, .cancel:
            return .black
        case .fill:
            return .white
        case .outlint:
            return .green
        case .disable:
            return .gray3
        }
    }
}

@frozen
enum MDSButtonHeightType {
    case h48
    case h40
    
    var height: CGFloat {
        switch self {
        case .h48:
            return 48
        case .h40:
            return 40
        }
    }
}

// MARK: - Button

final class MDSButton: UIButton {
    
    // MARK: - Property
    
    var text: String? = nil {
        didSet {
            setTitle(text, for: .normal)
        }
    }
    
    var type: MDSButtonType = .inactive {
        didSet {
            setBackgroundColor(type: type)
            setForegroundColor(type: type)
            setBorderColor(type: type)
        }
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle()
        makeRound()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Init UI
    
    private func setTitle() {
        // 폰트설정
    }
    
    private func setBackgroundColor(type: MDSButtonType) {
        backgroundColor = type.backgrounColor
    }
    
    private func setForegroundColor(type: MDSButtonType) {
        titleLabel?.textColor = type.titleColor
    }
    
    private func setBorderColor(type: MDSButtonType) {
        layer.borderWidth = 1
        layer.borderColor = type.boderColor.cgColor
    }
}

