//
//  OtherChatTableViewCell.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/25.
//

import UIKit

import SnapKit
import Then

final class OtherBubbleTableViewCell: BaseTableViewCell {
    
    // MARK: - UI Property
    
    private let backView = UIView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray4.cgColor
        $0.backgroundColor = UIColor.whiteGreen
        $0.makeRound()
    }
    
    private var messageLabel = UILabel().then {
        $0.textColor = .black
        $0.font = MDSFont.Body3_R14.font
        $0.numberOfLines = 0
    }
    
    private var timeLabel = UILabel().then {
        $0.textColor = .gray6
        $0.font = MDSFont.Title6_R12.font
    }
    
    // MARK: - UI Method
    
    override func configureAttribute() {
        contentView.backgroundColor = .white
    }
    
    override func configureHierarchy() {
        contentView.addSubviews(backView, messageLabel, timeLabel)
        
        backView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(16)
            make.width.lessThanOrEqualTo(264)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(backView).inset(10)
            make.leading.trailing.equalTo(backView).inset(16)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(backView)
            make.leading.equalTo(backView.snp.trailing).offset(8)
        }
    }
    
    // MARK: - Data
    
    func setData(_ message: String, _ time: String) {
        messageLabel.text = message
        timeLabel.text = time
    }
}
