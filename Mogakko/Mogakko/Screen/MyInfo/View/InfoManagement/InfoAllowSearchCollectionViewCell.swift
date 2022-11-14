//
//  InfoAllowSearchCollectionViewCell.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/14.
//

import UIKit

import SnapKit
import Then

final class InfoAllowSearchCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Property
    
    private var titleLabel = UILabel().then {
        $0.text = "내 번호 검색 허용"
        $0.font = MDSFont.Title4_R14.font
        $0.textColor = .black
    }
    
    private var switchButton = UISwitch().then {
        $0.isOn = true
        $0.tintColor = .green
    }
    
    // MARK: - Init UI
    
    override func configureAttribute() {
        contentView.backgroundColor = .white
    }
    
    override func configureHierarchy() {
        contentView.addSubviews(titleLabel, switchButton)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(Metric.margin)
        }
        
        switchButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(Metric.margin)
            make.width.equalTo(52)
            make.height.equalTo(28)
        }
    }
}

