//
//  InfoGenderCollectionViewCell.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/14.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class InfoGenderCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Property
    
    private var titleLabel = UILabel().then {
        $0.text = "내 성별"
        $0.font = MDSFont.Title4_R14.font
        $0.textColor = .black
    }
    
    private var manButton = MDSButton().then {
        $0.text = "남자"
    }
    
    private var womanButton = MDSButton().then {
        $0.text = "여자"
    }
    
    // MARK: - Init UI
    
    override func configureAttribute() {
        contentView.backgroundColor = .white
    }
    
    override func configureHierarchy() {
        contentView.addSubviews(titleLabel, manButton, womanButton)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
        
        manButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(26)
            make.height.equalTo(24)
            make.trailing.equalTo(womanButton.snp.leading).offset(-8)
        }
        
        womanButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(26)
            make.height.equalTo(24)
            make.trailing.equalToSuperview().inset(Metric.margin)
        }
    }
    
    // MARK: - Data
    
    func setData(_ gender: Gender) {
        if gender == .man {
            manButton.type = .fill
            womanButton.type = .inactive
        } else {
            manButton.type == .inactive
            womanButton.type = .fill
        }
    }
}
