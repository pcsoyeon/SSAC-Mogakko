//
//  StudyHeaderView.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/17.
//

import UIKit

final class StudyHeaderView: UICollectionReusableView {
    
    // MARK: - UI Property
    
    private var titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = MDSFont.Title6_R12.font
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAttribute()
        configureHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Method
    
    private func configureAttribute() {
        backgroundColor = .white
    }
    
    private func configureHierarchy() {
        addSubviews(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Metric.margin)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    // MARK: - Data
    
    func setData(_ title: String) {
        titleLabel.text = title
    }
}
