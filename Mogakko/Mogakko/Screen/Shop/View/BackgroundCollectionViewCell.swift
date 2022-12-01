//
//  BackgroundCollectionViewCell.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/30.
//

import UIKit

import SnapKit
import Then

final class BackgroundCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Property
    
    private let imageView = UIImageView().then {
        $0.makeRound()
        $0.clipsToBounds = true
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
            make.width.height.equalTo(165)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(12)
            make.top.equalToSuperview().inset(43.5)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(imageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
        }
        
        priceButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.width.equalTo(52)
            make.height.equalTo(20)
        }
    }
    
    // MARK: - Data
    
    func setBackgroundData(_ background: Background) {
        imageView.image = background.backgroundImage
        
        titleLabel.text = background.title
        descriptionLabel.text = background.description
    }
    
    func setPriceData(_ priceType: SesacPriceType) {
        priceButton.backgroundColor = priceType.backgroundColor
        priceButton.setTitle(priceType.text, for: .normal)
        priceButton.setTitleColor(priceType.textColor, for: .normal)
    }
}
