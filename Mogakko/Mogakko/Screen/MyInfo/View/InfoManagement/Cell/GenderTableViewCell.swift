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

final class GenderTableViewCell: BaseTableViewCell {
    
    // MARK: - Property
    
    var item: InfoManagementItem? {
        didSet {
            guard let item = item as? GenderItem else { return }
            
            if item.gender == 0 {
                manButton.type = .inactive
                womanButton.type = .fill
            } else {
                manButton.type = .fill
                womanButton.type = .inactive
            }
        }
    }
    
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
    
    // MARK: - UI Method
    
    override func configureAttribute() {
        contentView.backgroundColor = .white
    }
    
    override func configureHierarchy() {
        contentView.addSubviews(titleLabel, manButton, womanButton)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(Metric.margin)
        }
        
        manButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(56)
            make.height.equalTo(48)
            make.trailing.equalTo(womanButton.snp.leading).offset(-8)
        }
        
        womanButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(56)
            make.height.equalTo(48)
            make.trailing.equalToSuperview().inset(Metric.margin)
        }
    }
}
