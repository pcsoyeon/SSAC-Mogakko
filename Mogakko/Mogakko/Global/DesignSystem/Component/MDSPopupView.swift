//
//  MDSPopupView.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/13.
//

import UIKit

import SnapKit
import Then

final class MDSPopupView: UIView {
    
    // MARK: - UI Property
    
    private var backView = UIView().then {
        $0.backgroundColor = .white
        $0.makeRound(radius: 16)
    }
    
    private var titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = MDSFont.Body1_M16.font
    }
    
    private var subTitleLabel = UILabel().then {
        $0.textColor = .gray7
        $0.font = MDSFont.Title4_R14.font
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private var buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    
    private var cancelButton = UIButton().then {
        $0.titleLabel?.font = MDSFont.Body3_R14.font
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .gray2
        $0.makeRound()
    }
    
    private var confirmButton = UIButton().then {
        $0.titleLabel?.font = MDSFont.Body3_R14.font
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .green
        $0.makeRound()
    }
    
    // MARK: - Property
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var subtitle: String = "" {
        didSet {
            subTitleLabel.text = subtitle
        }
    }
    
    var numberOfLines: Int = 1 {
        didSet {
            if numberOfLines == 1 {
                
            } else {
                backView.snp.updateConstraints { make in
                    make.height.equalTo(178)
                }
            }
        }
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureHierarchy()
        configureAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Method
    
    private func configureHierarchy() {
        self.addSubview(backView)
        backView.addSubviews(titleLabel, subTitleLabel, buttonStackView)
        buttonStackView.addArrangedSubviews(cancelButton, confirmButton)
        
        backView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(344)
            make.height.equalTo(156)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Metric.margin)
            make.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalToSuperview().inset(Metric.margin)
            make.height.equalTo(48)
        }
    }
    
    private func configureAttribute() {
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    func addActionToButton(cancelCompletion: @escaping (() -> Void), comfirmCompletion: @escaping (() -> Void)) {
        cancelButton.addAction(UIAction(handler: { _ in
            cancelCompletion()
        }), for: .touchUpInside)
        
        confirmButton.addAction(UIAction(handler: { _ in
            comfirmCompletion()
        }), for: .touchUpInside)
    }
}
