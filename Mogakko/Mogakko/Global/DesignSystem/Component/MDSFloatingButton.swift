//
//  MDSFloatingButton.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/12.
//

import UIKit

import SnapKit
import Then

enum MDSFloatingButtonType {
    case plain
    case matching
    case matched
    
    var image: UIImage {
        switch self {
        case .plain:
            return Constant.Image.search
        case .matching:
            return Constant.Image.antenna
        case .matched:
            return Constant.Image.message
        }
    }
}

final class MDSFloatingButton: UIButton {
    
    // MARK: - Property
    
    var type: MDSFloatingButtonType = .plain {
        didSet {
            configureImage(type)
        }
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Init UI
    
    private func configureAttribute() {
        backgroundColor = .black
        makeRound(radius: Metric.floatingButtonRadius)
        
        self.snp.makeConstraints { make in
            make.width.height.equalTo(Metric.floatingButtonSize)
        }
    }
    
    private func configureImage(_ type: MDSFloatingButtonType) {
        setImage(type.image.withRenderingMode(.alwaysTemplate), for: .normal)
        tintColor = .white
        
    }
}
