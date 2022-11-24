//
//  MyStudyCollectionViewCell.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/19.
//

import UIKit

import SnapKit
import Then

final class MyStudyCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Property
    
    private var titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = MDSFont.Title4_R14.font
    }
    
    private var cancelButton = UIButton().then {
        $0.setImage(Constant.Image.closeSmall.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = .green
    }
    
    // MARK: - Property
    
    var type: StudyType = .wantToDo {
        didSet {
            setStudyType(type: type)
        }
    }
    
    // MARK: - UI Method
    
    override func configureAttribute() {
        contentView.backgroundColor = .white
        contentView.makeRound()
        contentView.layer.borderWidth = 1
    }
    
    override func configureHierarchy() {
        contentView.addSubviews(titleLabel, cancelButton)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Metric.margin)
            make.verticalEdges.equalToSuperview().inset(8)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(Metric.margin)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
    }
    
    // MARK: - Type
    
    private func setStudyType(type: StudyType) {
        titleLabel.textColor = type.textColor
        
        contentView.layer.borderColor = type.borderColor.cgColor
    }
    
    // MARK: - Data
    
    func setData(_ title: String) {
        titleLabel.text = title
    }
}
