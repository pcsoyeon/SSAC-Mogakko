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
            guard let item = item as? WithdrawItem else { return }
        }
    }
    
    // MARK: - UI Property
    
    var withdrawButton = UIButton().then {
        $0.setTitle("회원 탈퇴", for: .normal)
        $0.titleLabel?.font = MDSFont.Title4_R14.font
        $0.setTitleColor(.black, for: .normal)
    }
    
    // MARK: - UI Method
    
    override func configureAttribute() {
        backgroundColor = .white
    }
    
    override func configureHierarchy() {
        addSubview(withdrawButton)
        
        withdrawButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(13)
            make.leading.equalToSuperview().inset(Metric.margin)
        }
    }
}


