//
//  InfoCardTableViewCell.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/15.
//

import UIKit

import SnapKit
import Then

final class CardView: BaseView {
    
    // MARK: - Property
    
    var imageItem: InfoManagementItem? {
        didSet {
            guard let item = imageItem as? ImageItem else { return }
            backgroundImageView.image = UIImage(named: "sesac_background_\(item.background+1)")
            sesacImageView.image = UIImage(named: "sesac_face_\(item.sesac+1)")
        }
    }
    
    var cardItem: InfoManagementItem? {
        didSet {
            guard let item = cardItem as? CardItem else { return }
            nicknameLabel.text = item.nickname
            reviewContentLabel.text = item.review
            
            if item.review == "" {
                reviewContentLabel.text = "첫 리뷰를 기다리는 중이에요!"
                reviewContentLabel.textColor = .gray6
            }
        }
    }
    
    var isExpanded: Bool = false {
        didSet {
            if isExpanded {
                UIView.animate(withDuration: 3, delay: 0.1, options: .curveEaseInOut) { [weak self] in
                    guard let self = self else { return }
                    
                    self.snp.updateConstraints { make in
                        make.height.equalTo(194 + 310  + 16)
                    }
                }
                
                expandButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            } else {
                UIView.animate(withDuration: 3, delay: 0.1, options: .curveEaseInOut) { [weak self] in
                    guard let self = self else { return }
                    
                    self.snp.updateConstraints { make in
                        make.height.equalTo(194 + 58 + 16)
                    }
                }
                
                expandButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            }
        }
    }
    
    // MARK: - UI Property
    
    private let backgroundImageView = UIImageView().then {
        $0.makeRound()
    }
    
    private let sesacImageView = UIImageView()
    
    private let nicknameLabel = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.font = MDSFont.Title1_M16.font
    }
    
    var expandButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.down"), for: .normal)
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
        backgroundColor = .white
    }
    
    override func configureHierarchy() {
        addSubviews(backgroundImageView, stackView)
        stackView.addSubviews(nicknameLabel, expandButton, titleLabel, collectionView, reviewLabel, reviewContentLabel)
        backgroundImageView.addSubview(sesacImageView)
        
        snp.makeConstraints { make in
            make.width.equalTo(self.frame.width)
            make.height.equalTo(194 + 58 + 16)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalTo(Metric.margin)
            make.horizontalEdges.equalToSuperview().inset(Metric.margin)
            make.height.equalTo(194)
        }
        
        sesacImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(19)
            make.width.height.equalTo(184)
            make.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.bottom)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.leading.equalTo(16)
            make.height.equalTo(26)
        }
        
        expandButton.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.centerY.equalTo(nicknameLabel.snp.centerY)
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
    }
}

