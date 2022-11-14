//
//  GenderCollectionViewCell.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/08.
//

import UIKit

import SnapKit
import Then

final class GenderCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Property
    
    private var genderImageView = UIImageView()
    
    private var genderLabel = UILabel().then {
        $0.textColor = .black
        $0.font = MDSFont.Title2_R16.font
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .whiteGreen : .white
            contentView.layer.borderWidth = isSelected ? 0 : 1
        }
    }
    
    // MARK: - UI Method
    
    override func configureAttribute() {
        contentView.backgroundColor = .white
        
        contentView.layer.borderColor = UIColor.gray3.cgColor
        contentView.layer.borderWidth = 1
        
        contentView.makeRound()
    }
    
    override func configureHierarchy() {
        contentView.addSubviews(genderLabel, genderImageView)
        
        genderLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(14)
        }
        
        genderImageView.snp.makeConstraints { make in
            make.bottom.equalTo(genderLabel.snp.top).offset(2)
            make.width.height.equalTo(64)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Data
    
    func setData(_ gender: Gender) {
        genderImageView.image = gender.image
        genderLabel.text = gender.text
    }
}
