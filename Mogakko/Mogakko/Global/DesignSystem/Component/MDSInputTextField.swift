//
//  MDSTextField.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/07.
//

import UIKit

import SnapKit
import Then

final class MDSInputTextField: UITextField {
    
    // MARK: - UI Property
    
    private var lineView = UIView()
    
    // MARK: - Property
    
    override var placeholder: String? {
        didSet { setPlaceholder() }
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
    
    // MARK: - Set UI
    
    private func setUI() {
        setPadding()
        setState()
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
    
    private func setState() {
        borderStyle = .none
        
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
    
}
