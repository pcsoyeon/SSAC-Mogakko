//
//  TitleCollectionView.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/15.
//

import UIKit

import SnapKit
import Then

final class TitleCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Title
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    // MARK: - UI Property
    
    private var titleLabel = UILabel().then {
        $0.font = MDSFont.Title4_R14.font
    }
    
    var isActive: Bool = false {
        didSet {
            contentView.backgroundColor = isActive ? .green : .white
            titleLabel.textColor = isActive ? .white : .black
            contentView.layer.borderColor = isActive ? UIColor.green.cgColor : UIColor.gray4.cgColor
        }
    }
    
    // MARK: - UI Method
    
    override func configureAttribute() {
        contentView.layer.borderWidth = 1
        contentView.makeRound()
    }

    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
