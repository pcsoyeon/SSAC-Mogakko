//
//  ReviewCollectionViewCell.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/20.
//

import UIKit

import SnapKit
import Then

protocol ReviewCollectionViewCellDelegate: AnyObject {
    func numberOfLines(_ numberOfLines: Int)
}

final class ReviewCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Property
    
    private var textLabel = UILabel().then {
        $0.font = MDSFont.Body3_R14.font
        $0.numberOfLines = 0
    }
    
    // MARK: - Property
    
    var delegate: ReviewCollectionViewCellDelegate?
    
    // MARK: - UI Method
    
    override func configureAttribute() {
        contentView.backgroundColor = .white
    }
    
    override func configureHierarchy() {
        contentView.addSubview(textLabel)
        
        textLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Data
    
    func setData(_ comment: String) {
        if comment == "" {
            textLabel.text = "첫 리뷰를 기다리는 중이에요"
            textLabel.textColor = .gray6
        } else {
            textLabel.text = comment
            textLabel.textColor = .black
            
            delegate?.numberOfLines(textLabel.countCurrentLines())
        }
    }
}
