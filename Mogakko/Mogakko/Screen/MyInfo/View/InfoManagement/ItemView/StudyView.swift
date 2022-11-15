//
//  InfoStudyCollectionViewCell.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/14.
//

import UIKit

import SnapKit
import Then

final class StudyView: BaseView {
    
    // MARK: - Property
    
    var item: InfoManagementItem? {
        didSet {
            guard let item = item as? StudyItem else { return }
            textField.text = item.study
        }
    }
    
    // MARK: - UI Property
    
    private var titleLabel = UILabel().then {
        $0.text = "자주 하는 스터디"
        $0.font = MDSFont.Title4_R14.font
        $0.textColor = .black
    }
    
    var textField = MDSInputTextField().then {
        $0.type = .inactive
        $0.placeholder = "스터디를 입력해주세요"
    }
    
    // MARK: - UI Method
    
    override func configureAttribute() {
        backgroundColor = .white
    }
    
    override func configureHierarchy() {
        addSubviews(titleLabel, textField)
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(13)
            make.leading.equalToSuperview().inset(Metric.margin)
        }
        
        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(Metric.margin)
            make.width.equalTo(164)
        }
    }
}
