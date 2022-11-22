//
//  CardViewTableViewCell.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/22.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class TestTableViewCell: BaseTableViewCell {
    
    // MARK: - Property
    
    var isExpaned: Bool = false {
        didSet {
            
        }
    }
    
    
    var study: [String] = [" "] {
        didSet {
            studyCollectionView.reloadData()
        }
    }
    private var reputationTitle: [String] = ["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 실력", "유익한 시간"]
    
    // MARK: - UI Property
    
    // 이미지
    private let backgroundImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.makeRound()
    }
    private let sesacImageView = UIImageView()
    
    // 김새싹 ~ 리뷰까지 담을 stackview
    private lazy var infoStackView = UIStackView().then {
        $0.clipsToBounds = true
        $0.makeRound()
        $0.layer.borderColor = UIColor.gray3.cgColor
        $0.layer.borderWidth = 1
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .fill
        $0.spacing = 0
        
        $0.addArrangedSubviews(nicknameView, titleStackView, studyStackView, reviewStackView)
    }
    
    // 이름 view
    private let nicknameView = UIView()
    private let nicknameLabel = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.font = MDSFont.Title1_M16.font
    }
    var expandButton = UIButton().then {
        $0.backgroundColor = .clear
    }
    private var expandIconImageView = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .black
    }
    
    // 타이틀 뷰
    private lazy var titleStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .fill
        $0.spacing = 16
        $0.addArrangedSubviews(titleLabel, titleCollectionView)
    }
    private let titleLabel = UILabel().then {
        $0.text = "새싹 타이틀"
        $0.font = MDSFont.Title3_M14.font
        $0.textColor = .black
    }
    private lazy var titleCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout).then {
        $0.isScrollEnabled = false
        $0.delegate = self
        $0.dataSource = self
    }
    
    private var collectionLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }
    
    
    // 스터디 뷰
    private lazy var studyStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .fill
        $0.spacing = 16
        $0.addArrangedSubviews(studyLabel, studyCollectionView)
    }
    private let studyLabel = UILabel().then {
        $0.text = "스터디 타이틀"
        $0.font = MDSFont.Title3_M14.font
        $0.textColor = .black
    }
    private lazy var studyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout).then {
        $0.isScrollEnabled = false
        $0.delegate = self
        $0.dataSource = self
    }
    
    // 리뷰 뷰
    private lazy var reviewStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .fill
        $0.spacing = 16
        $0.addArrangedSubviews(reviewLabel, reviewContentLabel)
    }
    private let reviewLabel = UILabel().then {
        $0.text = "스터디 타이틀"
        $0.font = MDSFont.Title3_M14.font
        $0.textColor = .black
    }
    private let reviewContentLabel = UILabel().then {
        $0.text = "스터디 타이틀"
        $0.font = MDSFont.Body3_R14.font
        $0.textColor = .gray6
    }
    
    override func configureAttribute() {
        contentView.backgroundColor = .white
    }
    
    override func configureHierarchy() {
        contentView.addSubviews(backgroundImageView, infoStackView)
        backgroundImageView.addSubview(sesacImageView)
        
//        backgroundImageView.snp.makeConstraints { make in
//            make.top.horizontalEdges.equalToSuperview()
//            make.height.equalTo(194)
//        }
//        sesacImageView.snp.makeConstraints { make in
//            make.top.equalToSuperview().inset(19)
//            make.width.height.equalTo(184)
//            make.centerX.equalToSuperview()
//        }
//
//        infoStackView.snp.makeConstraints { make in
//            make.top.equalTo(backgroundImageView.snp.bottom)
//            make.horizontalEdges.bottom.equalToSuperview()
//        }
//
//        nicknameView.snp.makeConstraints { make in
//            make.height.equalTo(58)
//        }
//        nicknameView.addSubviews(nicknameLabel, expandButton, expandIconImageView)
//        nicknameLabel.snp.makeConstraints { make in
//            make.top.leading.equalToSuperview().inset(16)
//            make.height.equalTo(26)
//        }
//        expandButton.snp.makeConstraints { make in
//            make.horizontalEdges.verticalEdges.equalToSuperview()
//        }
//        expandIconImageView.snp.makeConstraints { make in
//            make.width.height.equalTo(16)
//            make.trailing.equalToSuperview().inset(16)
//            make.centerY.equalTo(nicknameLabel.snp.centerY)
//        }
//
//        [titleCollectionView, studyCollectionView].forEach {
//            $0.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.reuseIdentifier)
//        }
    }
}

extension TestTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (contentView.frame.width - 16 - 16 - 8) / 2
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

extension TestTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == titleCollectionView {
            return reputationTitle.count
        } else {
            return study.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.reuseIdentifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
    
    
}
