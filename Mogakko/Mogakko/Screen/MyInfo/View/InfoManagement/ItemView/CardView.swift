//
//  InfoCardTableViewCell.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/15.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

@frozen
enum CardViewType {
    case plain
    case info
}

struct CardCollectionItem: Hashable {
    var id: UUID
    var text: String
}

final class CardView: BaseView {
    
    // MARK: - Property
    
    var cardViewType: CardViewType = .plain
    
    var isExpanded: Bool = false {
        didSet {
            if isExpanded {
                collectionView.isHidden = false
//                let height = collectionView.collectionViewLayout.collectionViewContentSize.height
                if cardViewType == .plain {
                    collectionView.snp.updateConstraints { make in
                        make.height.equalTo(410)
                    }
                }
            } else {
                collectionView.isHidden = true
            }
        }
    }
    
    private var reputationTitle: [String] = ["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 실력", "유익한 시간"]
    private var reputation: [Int] = Array(repeating: 0, count: 6)
    
    var imageItem = BehaviorRelay<ImageItem>(value: ImageItem(background: 0, sesac: 0))
    var cardItem = BehaviorRelay<CardItem>(value: CardItem(nickname: "", reputation: [], comment: [], studyList: []))
    
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
        $0.addArrangedSubviews(nicknameView, collectionView)
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
        $0.backgroundColor = .clear
    }
    private var expandIconImageView = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .black
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout()).then {
        $0.backgroundColor = .white
        $0.isScrollEnabled = false
        $0.isUserInteractionEnabled = false
    }
    
    // MARK: - Property
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, CardCollectionItem>!
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Method
    
    override func configureAttribute() {
        backgroundColor = .white
        configureDataSource()
        bind()
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
        
        nicknameView.addSubviews(nicknameLabel, expandButton, expandIconImageView)
        nicknameView.snp.makeConstraints { make in
            make.height.equalTo(58)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.height.equalTo(26)
        }
        expandButton.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview()
        }
        expandIconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(nicknameLabel.snp.centerY)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(nicknameView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(310 - 58 - 20)
        }
    }
    
    private func bind() {
        imageItem
            .skip(1)
            .withUnretained(self)
            .bind { view, item in
                view.backgroundImageView.image = UIImage(named: "sesac_background_\(item.background+1)")
                view.sesacImageView.image = UIImage(named: "sesac_face_\(item.sesac+1)")
            }
            .disposed(by: disposeBag)
        
        cardItem
            .skip(1)
            .withUnretained(self)
            .bind { view, item in
                view.nicknameLabel.text = item.nickname
                
                var titleItemList: [CardCollectionItem] = []
                for title in view.reputationTitle {
                    titleItemList.append(CardCollectionItem(id: UUID(), text: title))
                }
                
                var studyItemList: [CardCollectionItem] = []
                for study in item.studyList {
                    studyItemList.append(CardCollectionItem(id: UUID(), text: study))
                }
                
                var commentList: [String] = []
                if item.comment.isEmpty {
                    commentList.append("")
                } else {
                    commentList.append(item.comment[0])
                }
                
                var commentItemList: [CardCollectionItem] = []
                for comment in commentList {
                    commentItemList.append(CardCollectionItem(id: UUID(), text: comment))
                }
                
                for i in 0...5 {
                    view.reputation[i] = item.reputation[i]
                }
                
                switch view.cardViewType {
                case .plain:
                    var snapshot = NSDiffableDataSourceSnapshot<Int, CardCollectionItem>()
                    
                    snapshot.appendSections([0, 1, 2])
                    
                    snapshot.appendItems(titleItemList, toSection: 0)
                    snapshot.appendItems(studyItemList, toSection: 1)
                    snapshot.appendItems(commentItemList, toSection: 2)
                    view.dataSource.apply(snapshot)
                case .info:
                    var snapshot = NSDiffableDataSourceSnapshot<Int, CardCollectionItem>()
                    
                    snapshot.appendSections([0, 1])
                    
                    snapshot.appendItems(titleItemList, toSection: 0)
                    snapshot.appendItems(commentItemList, toSection: 1)
                    view.dataSource.apply(snapshot)
                }
            }
            .disposed(by: disposeBag)
    }
    
}

// MARK: - CollectionView

extension CardView {
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        
        return UICollectionViewCompositionalLayout.init(sectionProvider: { sectionIndex, environment in
            
            if self.cardViewType == .info {
                if sectionIndex == 0 {
                    let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(151), heightDimension: .absolute(32))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    item.edgeSpacing = .init(leading: .fixed(16), top: .fixed(8), trailing: .fixed(0), bottom: .fixed(8))
                    
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(128))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                    
                    let headerSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(26))
                    let header = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: headerSize,
                        elementKind: CardView.sectionHeaderElementKind,
                        alignment: .top
                    )
                    
                    let section = NSCollectionLayoutSection(group: group)
                    section.boundarySupplementaryItems = [header]
                    return section
                } else {
                    let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(128), heightDimension: .estimated(128))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                    
                    let headerSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(46))
                    let header = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: headerSize,
                        elementKind: CardView.sectionHeaderElementKind,
                        alignment: .top
                    )
                    
                    let section = NSCollectionLayoutSection(group: group)
                    section.boundarySupplementaryItems = [header]
                    return section
                }
            } else {
                if sectionIndex == 0 {
                    let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(151), heightDimension: .absolute(32))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    item.edgeSpacing = .init(leading: .fixed(16), top: .fixed(8), trailing: .fixed(0), bottom: .fixed(8))
                    
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(128))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                    
                    let headerSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(26))
                    let header = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: headerSize,
                        elementKind: CardView.sectionHeaderElementKind,
                        alignment: .top
                    )
                    
                    let section = NSCollectionLayoutSection(group: group)
                    section.boundarySupplementaryItems = [header]
                    return section
                } else if sectionIndex == 1 {
                    let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(128), heightDimension: .absolute(32))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    item.edgeSpacing = .init(leading: .fixed(16), top: .fixed(8), trailing: .fixed(0), bottom: .fixed(8))
                    
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                    
                    let headerSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(46))
                    let header = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: headerSize,
                        elementKind: CardView.sectionHeaderElementKind,
                        alignment: .top
                    )
                    
                    let section = NSCollectionLayoutSection(group: group)
                    section.boundarySupplementaryItems = [header]
                    return section
                } else {
                    let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(128), heightDimension: .estimated(128))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                    
                    let headerSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(46))
                    let header = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: headerSize,
                        elementKind: CardView.sectionHeaderElementKind,
                        alignment: .top
                    )
                    
                    let section = NSCollectionLayoutSection(group: group)
                    section.boundarySupplementaryItems = [header]
                    return section
                }
            }
            
        }, configuration: configuration)
    }
    
    private func configureDataSource() {
        let titleCellRegistration = UICollectionView.CellRegistration<TitleCollectionViewCell, CardCollectionItem>.init { cell, indexPath, itemIdentifier in
            cell.isActive = self.reputation[indexPath.item] > 0 ? true : false
            cell.setData(itemIdentifier.text)
        }
        
        let studyCellRegistration = UICollectionView.CellRegistration<StudyCollectionViewCell, CardCollectionItem>.init { cell, indexPath, itemIdentifier in
            cell.type = .nearby
            cell.setData(itemIdentifier.text)
        }
        
        let reviewCellRegistration = UICollectionView.CellRegistration<ReviewCollectionViewCell, CardCollectionItem>.init { cell, indexPath, itemIdentifier in
            cell.setData(itemIdentifier.text)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<StudyHeaderView>(elementKind: CardView.sectionHeaderElementKind) { (supplementaryView, string, indexPath) in
            
            switch self.cardViewType {
                
            case .plain:
                if indexPath.section == 0 {
                    supplementaryView.setData("새싹 타이틀")
                } else if indexPath.section == 1 {
                    supplementaryView.setData("하고 싶은 스터디")
                } else {
                    supplementaryView.setData("새싹 리뷰")
                }
            case .info:
                if indexPath.section == 0 {
                    supplementaryView.setData("새싹 타이틀")
                } else {
                    supplementaryView.setData("새싹 리뷰")
                }
            }            
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            switch self.cardViewType {
                
            case .plain:
                if indexPath.section == 0 {
                    let cell = collectionView.dequeueConfiguredReusableCell(using: titleCellRegistration, for: indexPath, item: itemIdentifier)
                    return cell
                } else if indexPath.section == 1 {
                    let cell = collectionView.dequeueConfiguredReusableCell(using: studyCellRegistration, for: indexPath, item: itemIdentifier)
                    return cell
                } else {
                    let cell = collectionView.dequeueConfiguredReusableCell(using: reviewCellRegistration, for: indexPath, item: itemIdentifier)
                    return cell
                }
            case .info:
                if indexPath.section == 0 {
                    let cell = collectionView.dequeueConfiguredReusableCell(using: titleCellRegistration, for: indexPath, item: itemIdentifier)
                    return cell
                } else {
                    let cell = collectionView.dequeueConfiguredReusableCell(using: reviewCellRegistration, for: indexPath, item: itemIdentifier)
                    return cell
                }
            }
        })
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
    }
}
