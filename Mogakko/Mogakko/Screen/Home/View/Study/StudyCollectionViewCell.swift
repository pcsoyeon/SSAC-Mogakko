//
//  StudyCollectionViewCel.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/17.
//

import UIKit

final class StudyCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Property
    
    private var titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = MDSFont.Title4_R14.font
    }
    
    // MARK: - Property
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    // MARK: - UI Method
    
    override func configureAttribute() {
        contentView.backgroundColor = .white
        contentView.backgroundColor = .red
    }
    
    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metric.margin)
            make.verticalEdges.equalToSuperview().inset(8)
        }
    }
}
