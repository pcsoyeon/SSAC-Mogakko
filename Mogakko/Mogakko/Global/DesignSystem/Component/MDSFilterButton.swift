//
//  MDSSquareButton.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/14.
//

import UIKit

@frozen
enum MDSFilterType {
    case total
    case man
    case woman
    
    var gender: Int {
        switch self {
        case .total:
            return 2
        case .man:
            return 1
        case .woman:
            return 0
        }
    }
    
    var text: String {
        switch self {
        case .total:
            return "전체"
        case .man:
            return "남자"
        case .woman:
            return "여자"
        }
    }
}

final class MDSFilterButton: UIButton {
    
    // MARK: - Property
    
    var type: MDSFilterType = .total {
        didSet {
            setText(type: type)
        }
    }
    
    var isActive: Bool = false {
        didSet {
            setTitleColor(isActive ? .white : .black, for: .normal)
            backgroundColor = isActive ? .green : .white
        }
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Init UI
    
    private func configureUI() {
        titleLabel?.font = MDSFont.Body3_R14.font
        
        snp.makeConstraints { make in
            make.width.height.equalTo(48)
        }
    }
    
    private func setText(type: MDSFilterType) {
        setTitle(type.text, for: .normal)
    }
}


