//
//  InfoStudyCollectionViewCell.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/14.
//

import UIKit

import SnapKit
import Then

final class InfoStudyCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Property
    
    private var titleLabel = UILabel().then {
        $0.text = "자주 하는 스터디"
        $0.font = MDSFont.Title4_R14.font
        $0.textColor = .black
    }
    
    private var textField = MDSInputTextField().then {
        $0.type = .inactive
        $0.placeholder = "스터디를 입력해주세요"
    }
    
    // MARK: - Init UI
    
    override func configureAttribute() {
        contentView.backgroundColor = .white
    }
    
    override func configureHierarchy() {
        contentView.addSubviews(titleLabel, textField)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(Metric.margin)
        }
        
        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(Metric.margin)
            make.width.equalTo(164)
        }
    }
}
