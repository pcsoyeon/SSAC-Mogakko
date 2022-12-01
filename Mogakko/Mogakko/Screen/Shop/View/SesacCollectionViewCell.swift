//
//  SesacCollectionViewCell.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/30.
//

import UIKit

import SnapKit
import Then

final class SesacCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Property
    
    private let imageView = UIImageView().then {
        $0.makeRound()
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor.gray2.cgColor
        $0.layer.borderWidth = 1
    }
    
    private var titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = MDSFont.Title2_R16.font
    }
    
    private var descriptionLabel = UILabel().then {
        $0.textColor = .black
        $0.font = MDSFont.Body3_R14.font
        $0.numberOfLines = 0
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private var priceButton = UIButton().then {
        $0.titleLabel?.font = MDSFont.Title5_M12.font
    }
    
    // MARK: - UI Method
    
    override func configureAttribute() {
        contentView.backgroundColor = .white
        
        priceButton.makeRound(radius: 10)
        priceButton.clipsToBounds = true
    }
    
    override func configureHierarchy() {
        contentView.addSubviews(imageView, titleLabel, descriptionLabel, priceButton)
        
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(165)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
        }
        
        priceButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(9)
            make.width.equalTo(52)
            make.height.equalTo(20)
        }
    }
    
    // MARK: - Data
    
    func setSesacData(_ sesac: Sesac) {
        imageView.image = sesac.image
        
        titleLabel.text = sesac.title
        descriptionLabel.text = sesac.description
    }
    
    func setPriceData(_ priceType: SesacPriceType) {
        priceButton.backgroundColor = priceType.backgroundColor
        priceButton.setTitle(priceType.text, for: .normal)
        priceButton.setTitleColor(priceType.textColor, for: .normal)
    }
}
