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
    
    var isMyInfo: Bool = false
    
    var isExpanded: Bool = false {
        didSet {
            if isExpanded {
                if isMyInfo {
                    titleView.isHidden = false
                    reviewView.isHidden = false
                    studyView.isHidden = true
                } else {
                    titleView.isHidden = false
                    reviewView.isHidden = false
                    studyView.isHidden = false
                }
            } else {
                titleView.isHidden = true
                reviewView.isHidden = true
                studyView.isHidden = true
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
                reviewContentLabel.textColor = .black
            } else {
                reviewContentLabel.text = item.comment[0]
                reviewContentLabel.textColor = .black
                moreButton.isHidden = false
            }
            
            reviewView.snp.updateConstraints { make in
                make.height.equalTo(24 + 18 + 16 + (reviewContentLabel.countCurrentLines() * 24) + 16)
            }
            
            for i in 0...5 {
                reputation.append(item.reputation[i])
            }
            if let studyList = item.studyList {
                self.studyList = studyList
            }
            
            studyCollectionView.snp.updateConstraints { make in
                make.height.equalTo(studyList.count / 2 * 32)
            }
        }
    }
    
    private var reputationTitle: [String] = ["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 실력", "유익한 시간"]
    private var reputation: [Int] = Array(repeating: 0, count: 6) {
        didSet {
            titleCollectionView.reloadData()
        }
    }
    
    private var studyList: [String] = [] {
        didSet {
            studyCollectionView.reloadData()
        }
    }
    
    // MARK: - UI Property
    
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .fill
        $0.spacing = 0
        $0.addArrangedSubviews(backgroundImageView, infoStackView)
    }
    
    private let backgroundImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.makeRound()
    }
    private let sesacImageView = UIImageView()
    
    private lazy var infoStackView = UIStackView().then {
        $0.clipsToBounds = true
        $0.makeRound()
        $0.layer.borderColor = UIColor.gray3.cgColor
        $0.layer.borderWidth = 1
        $0.addArrangedSubviews(nicknameView, titleView, studyView, reviewView)
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .fill
        $0.spacing = 0
    }
    
    private let nicknameView = UIView()
    private let nicknameLabel = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.font = MDSFont.Title1_M16.font
    }
    var expandButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        $0.tintColor = .black
    }
    
    private var titleView = UIView()
    private var titleLabel = UILabel().then {
        $0.text = "새싹 타이틀"
        $0.textColor = .black
        $0.font = MDSFont.Title6_R12.font
    }
    private lazy var titleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
                
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        
        return collectionView
    }()
    
    private let studyView = UIView()
    private var studyLabel = UILabel().then {
        $0.text = "하고 싶은 스터디"
        $0.textColor = .black
        $0.font = MDSFont.Title6_R12.font
    }
    private lazy var studyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false

        return collectionView
    }()
    
    private var reviewView = UIView()
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
    
    // MARK: - UI Method
    
    override func configureAttribute() {
        backgroundColor = .white
        
        titleCollectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.reuseIdentifier)
        titleCollectionView.dataSource = self
        titleCollectionView.delegate = self
        
        studyCollectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.reuseIdentifier)
        studyCollectionView.dataSource = self
        studyCollectionView.delegate = self
    }
    
    override func configureHierarchy() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview().inset(Metric.margin)
        }
        
        backgroundImageView.addSubview(sesacImageView)
        
        backgroundImageView.snp.makeConstraints { make in
            make.height.equalTo(194)
        }
        
        sesacImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(19)
            make.width.height.equalTo(184)
            make.centerX.equalToSuperview()
        }
        
        nicknameView.addSubviews(nicknameLabel, expandButton)
        nicknameView.snp.makeConstraints { make in
            make.height.equalTo(58)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.height.equalTo(26)
        }
        expandButton.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(nicknameLabel.snp.centerY)
        }
        
        titleView.addSubviews(titleLabel, titleCollectionView)
        titleView.snp.makeConstraints { make in
            make.height.equalTo(170)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.height.equalTo(18)
        }
        titleCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(112)
        }
        
        studyView.addSubviews(studyLabel, studyCollectionView)
        studyView.snp.makeConstraints { make in
            make.height.equalTo(90)
        }
        studyLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.height.equalTo(18)
        }
        studyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(studyLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(32)
        }
        
        reviewView.addSubviews(reviewLabel, reviewContentLabel)
        reviewView.snp.makeConstraints { make in
            make.height.equalTo(24 + 18 + 16 + (reviewContentLabel.countCurrentLines() * 24) + 16)
        }
        reviewLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
        }
        reviewContentLabel.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
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
        if collectionView == titleCollectionView {
            return reputationTitle.count
        } else {
            return studyList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == titleCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.reuseIdentifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
            cell.isSelected = reputation[indexPath.row] > 0 ? true : false
            cell.title = reputationTitle[indexPath.row]
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.reuseIdentifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
            cell.isSelected = false
            cell.title = studyList[indexPath.row]
            return cell
        }
    }
}
