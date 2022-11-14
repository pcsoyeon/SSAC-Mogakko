//
//  BaseCollectionViewCell.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/07.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAttribute()
        configureHierarchy()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureAttribute() {}
    func configureHierarchy() {}
}
