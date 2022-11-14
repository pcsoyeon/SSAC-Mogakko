//
//  InfoSliderCollectionViewCell.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/14.
//

import UIKit

import SnapKit
import Then

final class InfoSliderCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Property
    
    private var titleLabel = UILabel().then {
        $0.text = "상대방 연령대"
        $0.font = MDSFont.Title4_R14.font
        $0.textColor = .black
    }
    
    private var ageLabel = UILabel().then {
        $0.font = MDSFont.Title3_M14.font
        $0.textColor = .green
    }
    
    private var slider = MDSSlider().then {
        $0.minValue = 1
        $0.maxValue = 100
    }
    
    // MARK: - UI Method
    
    override func configureAttribute() {
        contentView.backgroundColor = .white
    }
    
    override func configureHierarchy() {
        contentView.addSubviews(titleLabel, ageLabel, slider)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(13)
            make.leading.equalToSuperview().inset(Metric.margin)
        }
        
        ageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(11)
            make.trailing.equalToSuperview().inset(Metric.margin)
        }
        
        slider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(1)
            make.leading.equalToSuperview().inset(Metric.margin)
            make.trailing.equalToSuperview().inset(29)
            make.height.equalTo(48)
        }
    }
}
