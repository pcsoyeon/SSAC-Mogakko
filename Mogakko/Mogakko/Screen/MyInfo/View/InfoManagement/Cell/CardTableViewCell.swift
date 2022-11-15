//
//  InfoCardTableViewCell.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/15.
//

import UIKit

import SnapKit
import Then

final class CardTableViewCell: BaseTableViewCell {
    
    // MARK: - Property
    
    var item: InfoManagementItem? {
        didSet {
            guard let item = item as? CardItem else { return }
            nicknameLabel.text = item.nickname
            reviewContentLabel.text = item.review
        }
    }
    
    // MARK: - UI Property
    
    private let nicknameLabel = UILabel().then {
        $0.textColor = .black
        $0.font = MDSFont.Title1_M16.font
    }
    
    private var iconImageView = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.down")
        $0.tintColor = .black
    }
    
    private lazy var stackView = UIView().then {
        $0.clipsToBounds = true
        $0.makeRound()
        $0.layer.borderColor = UIColor.gray3.cgColor
        $0.layer.borderWidth = 1
    }
    
    private var titleLabel = UILabel().then {
        $0.text = "새싹 타이틀"
        $0.textColor = .black
        $0.font = MDSFont.Title6_R12.font
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .green
        collectionView.isScrollEnabled = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return collectionView
    }()
    
    private var reviewLabel = UILabel().then {
        $0.text = "새싹 리뷰"
        $0.textColor = .black
        $0.font = MDSFont.Title6_R12.font
    }
    
    private var reviewContentLabel = UILabel().then {
        $0.text = "첫 리뷰를 기다리는 중이에요!"
        $0.textColor = .gray6
        $0.font = MDSFont.Body3_R14.font
    }
    
    // MARK: - UI Method
    
    override func configureAttribute() {
        contentView.backgroundColor = .white
    }
    
    override func configureHierarchy() {
        stackView.addSubviews(nicknameLabel, iconImageView, titleLabel, collectionView, reviewLabel, reviewContentLabel)
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.leading.equalTo(16)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.width.equalTo(12)
            make.height.equalTo(6)
            make.top.equalTo(26)
            make.trailing.equalToSuperview().inset(26)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(Metric.margin)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(Metric.margin)
            make.height.equalTo(112)
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(Metric.margin)
        }
        
        reviewContentLabel.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalToSuperview().inset(Metric.margin)
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
