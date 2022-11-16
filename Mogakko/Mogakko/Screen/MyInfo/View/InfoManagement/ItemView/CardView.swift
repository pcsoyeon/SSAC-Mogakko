//
//  InfoCardTableViewCell.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/15.
//

import UIKit

import SnapKit
import Then

@frozen
enum CardViewType {
    case plain
    case info
}

final class CardView: BaseView {
    
    // MARK: - Property
    
    var type: CardViewType = .info {
        didSet {
            if type == .info {
                setInfoLayout()
            } else {
                setPlainLayout()
            }
        }
    }
    
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
            
            if item.comment.isEmpty {
                reviewContentLabel.text = "첫 리뷰를 기다리는 중이에요!"
                reviewContentLabel.textColor = .gray6
            } else if item.comment.count == 1 {
                reviewContentLabel.text = item.comment[0]
            } else {
                reviewContentLabel.text = item.comment[0]
                moreButton.isHidden = false
            }
            
            reputation = item.reputation
        }
    }
    
    var touchUpExpandButton: Bool = false {
        didSet {
            if touchUpExpandButton {
                
                if type == .info {
                    let labelHeight = reviewContentLabel.countCurrentLines() * 24
                    
                    snp.updateConstraints { make in
                        make.height.equalTo(194 + 270 + labelHeight + 16 + 10)
                    }
                } else {
                    let labelHeight = reviewContentLabel.countCurrentLines() * 24
                    
                    snp.updateConstraints { make in
                        make.height.equalTo(194 + 270 + 165 + labelHeight + 16 + 10)
                    }
                }
                
                expandButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            } else {
                snp.updateConstraints { make in
                    make.height.equalTo(194 + 58 + 16)
                }
                
                expandButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            }
        }
    }
    
    private var reputation: [Int] = Array(repeating: 0, count: 6) {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var reputationTitle: [String] = ["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 실력", "유익한 시간"]
    
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
    
    private lazy var backView = UIView().then {
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
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
                
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
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
        $0.numberOfLines = 0
    }
    
    private var moreButton = UIButton().then {
        $0.setImage(Constant.Image.moreArrow, for: .normal)
        $0.isHidden = true
    }
    
    private var studyLabel = UILabel().then {
        $0.text = "하고 싶은 스터디"
        $0.textColor = .black
        $0.font = MDSFont.Title6_R12.font
    }
    
    private lazy var studyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
                
        collectionView.backgroundColor = .green
        collectionView.isScrollEnabled = false

        return collectionView
    }()
    
    // MARK: - UI Method
    
    override func configureAttribute() {
        backgroundColor = .white
    }
    
    override func configureHierarchy() {
        addSubviews(backgroundImageView, backView)
        backgroundImageView.addSubview(sesacImageView)
        
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
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.bottom)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    private func setInfoLayout() {
        backView.addSubviews(nicknameLabel, expandButton, titleLabel, collectionView, reviewLabel, moreButton, reviewContentLabel)
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(Metric.margin)
            make.height.equalTo(26)
        }
        
        expandButton.snp.makeConstraints { make in
            make.width.height.equalTo(26)
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
            make.leading.equalToSuperview().inset(Metric.margin)
        }
        
        moreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Metric.margin)
            make.centerY.equalTo(reviewLabel.snp.centerY)
        }
        
        reviewContentLabel.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalToSuperview().inset(Metric.margin)
        }
    }
    
    private func setPlainLayout() {
        backView.addSubviews(nicknameLabel, expandButton, titleLabel, collectionView, studyLabel, studyCollectionView, reviewLabel, moreButton, reviewContentLabel)
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(Metric.margin)
            make.height.equalTo(26)
        }
        
        expandButton.snp.makeConstraints { make in
            make.width.height.equalTo(26)
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
        
        studyLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(Metric.margin)
        }
        
        studyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(studyLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(Metric.margin)
            make.height.equalTo(112)
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(studyCollectionView.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(Metric.margin)
        }
        
        moreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Metric.margin)
            make.top.equalTo(studyCollectionView.snp.bottom).offset(24)
        }
        
        reviewContentLabel.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalToSuperview().inset(Metric.margin)
        }
    }
}

// MARK: - UICollectionView

extension CardView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 8) / 2
        let height = 32.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

extension CardView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reputationTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.reuseIdentifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        cell.isSelected = reputation[indexPath.row] > 0 ? true : false
        cell.title = reputationTitle[indexPath.row]
        return cell
    }
}
