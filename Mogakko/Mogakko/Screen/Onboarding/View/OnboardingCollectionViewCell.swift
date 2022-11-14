//
//  OnboardingCollectionViewCell.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/07.
//

import UIKit

final class OnboardingCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Property
    
    private var titleLabel = UILabel().then {
        $0.font = UIFont(name: "NotoSansCJKKR-Medium", size: 24)
        $0.numberOfLines = 0
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    private var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    override func configureAttribute() {
        contentView.backgroundColor = .white
    }
    
    override func configureHierarchy() {
        contentView.addSubviews(titleLabel, imageView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(72)
            make.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(56)
            make.width.height.equalTo(360)
            make.centerX.equalToSuperview()
        }
    }
    
    func setData(title: String, image: UIImage, index: Int) {
        imageView.image = image
        
        if index == 0 {
            titleLabel.setHighlighted(title, with: "위치 기반")
        } else if index == 1{
            titleLabel.setHighlighted(title, with: "스터디를 원하는 친구")
        } else {
            titleLabel.text = title
        }
    }
}
