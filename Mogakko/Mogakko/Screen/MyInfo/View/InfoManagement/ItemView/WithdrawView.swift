//
//  InfoWithdrawCollectionViewCell.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/14.
//

import UIKit

import SnapKit
import Then

final class WithdrawView: BaseView {
    
    // MARK: - Property
    
    var item: InfoManagementItem? {
        didSet {
            guard let item = item as? WithdrawView else { return }
        }
    }
    
    // MARK: - UI Property
    
    private var titleLabel = UILabel().then {
        $0.text = "회원 탈퇴"
        $0.font = MDSFont.Title4_R14.font
        $0.textColor = .black
    }
    
    // MARK: - UI Method
    
    override func configureAttribute() {
        backgroundColor = .white
    }
    
    override func configureHierarchy() {
        addSubview(titleLabel)
        
        snp.makeConstraints { make in
            make.width.equalTo(self.frame.width)
            make.height.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(Metric.margin)
        }
    }
}

