//
//  MDSMessageTextField.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/07.
//

import UIKit

@frozen
enum MDSMessageTextFieldType {
    case inactive
    case active
    case inactiveWithIcon
    case activeWithIcon
    
    var backgroundColor: UIColor {
        switch self {
        case .inactive, .active, .inactiveWithIcon, .activeWithIcon:
            return .gray1
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .inactive, .inactiveWithIcon:
            return .gray1
        case .active, .activeWithIcon:
            return .black
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .inactive, .active:
            return nil
        case .inactiveWithIcon:
            return Constant.Image.sendInact
        case .activeWithIcon:
            return Constant.Image.sendAct
        }
    }
}

final class MDSMessageTextField: UITextField {
    
    // MARK: - UI Property
    
    private let iconImageView = UIImageView()
    
    // MARK: - Property
    
    override var placeholder: String? {
        didSet { setPlaceholder() }
    }
    
    var type: MDSMessageTextFieldType = .inactive {
        didSet {
            setBackgroundColor(type: type)
            setTextColor(type: type)
            setLeftIconImage(type: type)
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
        setPadding()
    }
    
    private func setLayout() {
        addSubviews(iconImageView)
        
        snp.makeConstraints { make in
            make.height.equalTo(Metric.messageTextFieldHeight)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(Metric.messageTextFieldTrailing)
            make.width.height.equalTo(Metric.messageTextFieldIconSize)
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
    
    private func setBackgroundColor(type: MDSMessageTextFieldType) {
        backgroundColor = type.backgroundColor
    }
    
    private func setTextColor(type: MDSMessageTextFieldType) {
        textColor = type.textColor
    }
    
    private func setLeftIconImage(type: MDSMessageTextFieldType) {
        iconImageView.image = type.icon
    }
}
