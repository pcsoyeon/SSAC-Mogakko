//
//  BaseView.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/15.
//

import UIKit

class BaseView: UIView {
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAttribute()
        configureHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // 런타임 오류
    }
    
    // MARK: - UI Method
    
    func configureAttribute() { }
    
    func configureHierarchy() { }
}

