//
//  MDSNavigationBar.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/07.
//

import UIKit

import SnapKit
import Then

final class NDSNavigationBar: UIView {
    
    // MARK: - Properties
    
    private var viewController = UIViewController()
    public var backButton = BackButton()
    
    private var titleLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
        // 폰트 설정
    }
    
    var backButtonIsHidden: Bool = true {
        didSet {
            backButton.isHidden = backButtonIsHidden
        }
    }
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    // MARK: - Initializer
    
    public init(_ viewController: UIViewController) {
        super.init(frame: .zero)
        self.backButton = BackButton(root: viewController)
        configureUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Method
    
    private func configureUI() {
        backgroundColor = .white
    }
    
    private func setLayout() {
        addSubviews(backButton, titleLabel)
                
        snp.makeConstraints { make in
            make.height.equalTo(Metric.navigationHeight)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(Metric.navigationButtonLeading)
            make.width.height.equalTo(Metric.navigationButtonSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(Metric.navigationButtonBottom)
            make.centerX.equalToSuperview()
        }
    }
}

