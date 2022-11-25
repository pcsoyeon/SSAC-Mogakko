//
//  HeaderTableViewCell.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/25.
//

import UIKit

import SnapKit
import Then

final class HeaderTableViewCell: BaseTableViewCell {
    
    // MARK: - UI Property
    
    private var dateView = UIView().then {
        $0.backgroundColor = .gray7
        $0.makeRound(radius: 14)
    }
    
    private var dateLabel = UILabel().then {
        $0.textColor = .white
        $0.font = MDSFont.Title5_M12.font
    }
    
    private let titleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.spacing = 4
    }
    
    private let alarmImageView = UIImageView().then {
        $0.image = Constant.Image.bell
    }
    
    private var titleLabel = UILabel().then {
        $0.font = MDSFont.Title3_M14.font
        $0.textColor = .gray7
    }
    
    private let subtitleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = MDSFont.Title4_R14.font
        $0.textColor = .gray6
        $0.text = "채팅을 통해 약속을 정해보세요 :)"
    }
    
    // MARK: - UI Method
    
    override func configureHierarchy() {
        contentView.addSubviews(dateView, titleStackView, subtitleLabel)
        titleStackView.addArrangedSubviews(alarmImageView, titleLabel)
        
        dateView.addSubview(dateLabel)
        
        dateView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Metric.margin)
            make.centerX.equalToSuperview()
            make.width.equalTo(114)
            make.height.equalTo(28)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        titleStackView.snp.makeConstraints { make in
            make.top.equalTo(dateView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    override func configureAttribute() {
        contentView.backgroundColor = .white
    }
    
    private func calculateViewWidth(_ text: String) -> CGFloat {
        let textLabel = UILabel()
        textLabel.text = text
        textLabel.font = MDSFont.Title5_M12.font
        textLabel.sizeToFit()
        return textLabel.frame.width + (Metric.margin * 2)
    }
    
    // MARK: - Data
    
    func setData(date: String, nick: String) {
        dateLabel.text = date
        dateView.snp.updateConstraints { make in
            make.width.equalTo(calculateViewWidth(date))
        }
        titleLabel.text = "\(nick)님과 매칭되었습니다"
    }
}
