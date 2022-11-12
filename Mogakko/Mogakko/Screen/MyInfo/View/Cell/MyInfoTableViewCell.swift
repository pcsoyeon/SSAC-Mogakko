//
//  MyInfoTableViewCell.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/13.
//

import UIKit

import SnapKit
import Then

final class MyInfoTableViewCell: BaseTableViewCell {
    
    // MARK: - UI Property
    
    private let iconImageView = UIImageView()
    
    private let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = MDSFont.Title2_R16.font
    }
    
    // MARK: - UI Method
    
    override func configureAttribute() {
        contentView.backgroundColor = .white
    }
    
    override func configureHierarchy() {
        contentView.addSubviews(iconImageView, titleLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(Metric.margin)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
        }
    }
    
    // MARK: - Data
    
    func setData(_ data: MyInfo) {
        iconImageView.image = data.image
        titleLabel.text = data.title
    }
}
