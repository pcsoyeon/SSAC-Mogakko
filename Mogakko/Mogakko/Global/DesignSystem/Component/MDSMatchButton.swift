//
//  MDSMatchButton.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/22.
//

import UIKit

@frozen
enum MDSMatchType {
    case propose
    case accept
    case hidden
    
    var backgrounColor: UIColor {
        switch self {
        case .propose:
            return .error
        case .accept:
            return .success
        case .hidden:
            return .clear
        }
    }
    
    var text: String {
        switch self {
        case .propose:
            return "요청하기"
        case .accept:
            return "수락하기"
        case .hidden:
            return ""
        }
    }
}

final class MDSMatchButton: UIButton {
    
    // MARK: - Property
    
    var type: MDSMatchType = .accept {
        didSet {
            setType(type: type)
        }
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        makeRound()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Init UI
    
    private func configureUI() {
        titleLabel?.font = MDSFont.Title3_M14.font
        setTitleColor(.white, for: .normal)
        
        snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
    }
    
    private func setType(type: MDSMatchType) {
        setTitle(type.text, for: .normal)
        backgroundColor = type.backgrounColor
    }
}


