//
//  StudyCollectionViewCel.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/17.
//

import UIKit

enum StudyType {
    case recommend
    case nearby
    case wantToDo
    
    var borderColor: UIColor {
        switch self {
        case .recommend:
            return .error
        case .nearby:
            return .gray4
        case .wantToDo:
            return .green
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .recommend:
            return .error
        case .nearby:
            return .black
        case .wantToDo:
            return .green
        }
    }
}

final class StudyCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Property
    
    private var titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = MDSFont.Title4_R14.font
    }
    
    // MARK: - Property
    
    var type: StudyType = .nearby {
        didSet {
            setStudyType(type: type)
        }
    }
    
    // MARK: - UI Method
    
    override func configureAttribute() {
        contentView.backgroundColor = .white
        contentView.makeRound()
        contentView.layer.borderWidth = 1
    }
    
    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metric.margin)
            make.verticalEdges.equalToSuperview().inset(8)
        }
    }
    
    // MARK: - Type
    
    private func setStudyType(type: StudyType) {
        titleLabel.textColor = type.textColor
        
        contentView.layer.borderColor = type.borderColor.cgColor
    }
    
    // MARK: - Data
    
    func setData(_ title: String) {
        titleLabel.text = title
    }
}
