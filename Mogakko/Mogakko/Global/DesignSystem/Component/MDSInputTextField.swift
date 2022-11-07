//
//  MDSTextField.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/07.
//

import UIKit

import SnapKit
import Then

@frozen
enum MDSInputTextFieldType {
    case inactive
    case focus
    case active
    case disable
    
    var backgroundColor: UIColor {
        switch self {
        case .inactive, .active, .focus:
            return .white
        case .disable:
            return .gray3
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .inactive, .disable:
            return .gray7
        case .focus, .active:
            return .black
        }
    }
    
    var lineColor: UIColor {
        switch self {
        case .inactive, .active, .disable:
            return .gray3
        case .focus:
            return .black
        }
    }
}

final class MDSInputTextField: UITextField {
    
    // MARK: - UI Property
    
    private var lineView = UIView()
    
    // MARK: - Property
    
    override var placeholder: String? {
        didSet { setPlaceholder() }
    }
    
    var type: MDSInputTextFieldType = .inactive {
        didSet {
            setState(type: type)
        }
    }
    
    // MARK: - Initialize
    
    public init() {
        super.init(frame: .zero)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Init UI
    
    private func setUI() {
        borderStyle = .none
        
        font = MDSFont.Title4_R14.font
        
        setPadding()
    }
    
    private func setLayout() {
        addSubviews(lineView)
        
        snp.makeConstraints { make in
            make.height.equalTo(Metric.inputTextFieldHeight)
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setPlaceholder() {
        guard let placeholder = placeholder else {
            return
        }

        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor.gray7]
        )
    }
    
    // MARK: - Set UI
    
    private func setState(type: MDSInputTextFieldType) {
        backgroundColor = type.backgroundColor
        
        lineView.backgroundColor = type.lineColor
        
        textColor = type.textColor
    }
    
}
