//
//  MDSNavigationBar.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/07.
//

import UIKit

import SnapKit
import Then

final class MDSNavigationBar: UIView {
    
    // MARK: - Properties
    
    private var viewController = UIViewController()
    public var backButton = BackButton()
    
    private var titleLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = MDSFont.Title3_M14.font
    }
    
    private var lineView = UIView().then {
        $0.backgroundColor = .gray1
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
    
    var underLineIsHidden: Bool = false {
        didSet {
            lineView.isHidden = underLineIsHidden
        }
    }
    
    // MARK: - Initializer
    
    init(_ viewController: UIViewController) {
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
        addSubviews(backButton, titleLabel, lineView)

        backButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(Metric.navigationButtonLeading)
            make.width.height.equalTo(Metric.navigationButtonSize)
        }

        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(Metric.navigationButtonBottom)
            make.centerX.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

