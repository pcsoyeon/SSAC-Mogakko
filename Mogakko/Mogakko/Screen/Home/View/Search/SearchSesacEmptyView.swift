//
//  SearchEmptyView.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/19.
//

import UIKit

import SnapKit
import Then

final class SearchSesacEmptyView: BaseView {
    
    // MARK: - Property
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var subtitle: String = "" {
        didSet {
            subtitleLabel.text = subtitle
        }
    }
    
    // MARK: - UI Property
    
    private var imageView = UIImageView().then {
        $0.image = Constant.Image.img
    }
    
    private var titleLabel = UILabel().then {
        $0.font = MDSFont.Display1_R20.font
        $0.textColor = .black
    }
    
    private var subtitleLabel = UILabel().then {
        $0.font = MDSFont.Title4_R14.font
        $0.textColor = .gray7
    }
    
    var changeButton = MDSButton().then {
        $0.text = "스터디 변경하기"
        $0.type = .fill
        $0.heightType = .h48
    }
    
    var refreshButton = UIButton().then {
        $0.setImage(Constant.Image.refresh, for: .normal)
    }
    
    // MARK: - UI Method
    
    override func configureAttribute() {
        backgroundColor = .white
    }
    
    override func configureHierarchy() {
        addSubviews(imageView, titleLabel, subtitleLabel, changeButton, refreshButton)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(183)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(64)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(36)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        changeButton.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(Metric.margin)
            make.trailing.equalToSuperview().inset(72)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(Metric.margin)
            make.leading.equalTo(changeButton.snp.trailing).offset(8)
        }
    }
}
