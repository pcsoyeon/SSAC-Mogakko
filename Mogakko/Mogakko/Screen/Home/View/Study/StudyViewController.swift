//
//  StudyViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/17.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class StudyViewController: UIViewController {
    
    // MARK: - UI Property
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout()).then {
        $0.backgroundColor = .white
    }
    
    // MARK: - Property
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>!
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    var list: [String] = []
    var selectedList: [String] = []
    
    var viewModel = StudyViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureAttribute()
        bind()
    }
}

extension StudyViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        view.addSubviews(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.verticalEdges.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureAttribute() {
        view.backgroundColor = .white
        
        configureDataSource()
    }
    
    func bind() {
        viewModel.recommend
            .withUnretained(self)
            .bind { vc, list in
                print(list)
                var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
                
                snapshot.appendSections([0, 1])
                snapshot.appendItems(list, toSection: 0)
                self.dataSource.apply(snapshot)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - CollectionView

extension StudyViewController {
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        
        return UICollectionViewCompositionalLayout.init(sectionProvider: { sectionIndex, environment in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(128), heightDimension: .estimated(128))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.edgeSpacing = .init(leading: .fixed(8), top: .fixed(8), trailing: .fixed(8), bottom: .fixed(8))
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(128))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(46))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: StudyViewController.sectionHeaderElementKind,
                alignment: .top
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [header]
            return section
            
        }, configuration: configuration)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<StudyCollectionViewCell, String>.init { cell, indexPath, itemIdentifier in
            cell.title = itemIdentifier
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<StudyHeaderView>(elementKind: StudyViewController.sectionHeaderElementKind) { (supplementaryView, string, indexPath) in
            if indexPath.section == 0 {
                supplementaryView.title = "지금 주변에는"
            } else {
                supplementaryView.title = "내가 하고 싶은"
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
    }
}
