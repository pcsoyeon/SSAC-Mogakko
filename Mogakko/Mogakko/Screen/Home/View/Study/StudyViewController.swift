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
    
    private lazy var navigationBar = MDSNavigationBar(self).then {
        $0.backButtonIsHidden = false
        $0.underLineIsHidden = true
        $0.addSubview(searchBar)
    }
    
    private lazy var searchBar = UISearchBar().then {
        $0.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        $0.backgroundImage = UIImage()
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout()).then {
        $0.backgroundColor = .white
    }
    
    private var searchButton = MDSButton().then {
        $0.type = .fill
        $0.text = "새싹 찾기"
        $0.heightType = .h48
    }
    
    // MARK: - Property
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>!
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    var mapLatitude = 0.0
    var mapLongitude = 0.0
    
    private var viewModel = StudyViewModel()
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
        view.addSubviews(navigationBar, collectionView, searchButton)
        
        navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchBar.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(48)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(Metric.margin)
            make.top.bottom.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(Metric.margin)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).inset(-Metric.margin)
        }
    }
    
    func configureAttribute() {
        view.backgroundColor = .white
        
        configureNavigationBar()
        configureSearchBar()
        configureDataSource()
    }
    
    private func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    private func configureSearchBar() {
        searchBar.tintColor = .black
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.tintColor = .black
            textfield.backgroundColor = .gray1
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray6])
            textfield.textColor = .black
        }
    }
    
    func bind() {
        viewModel.requestSearch(request: SearchRequest(lat: mapLatitude, long: mapLongitude)) { [weak self] error in
            guard let vc = self else { return }
            
            if let error = error {
                switch error {
                case .takenUser, .invalidNickname:
                    return
                case .invalidAuthorization:
                    vc.showToast(message: "\(String(describing: error.errorDescription))")
                case .unsubscribedUser:
                    vc.showToast(message: "\(String(describing: error.errorDescription))")
                case .serverError:
                    vc.showToast(message: "\(String(describing: error.errorDescription))")
                case .emptyParameters:
                    vc.showToast(message: "\(String(describing: error.errorDescription))")
                }
            }
        }
        
        viewModel.nearby
            .withUnretained(self)
            .bind { vc, list in
                print(list)
                var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
                
                snapshot.appendSections([0, 1])
                snapshot.appendItems(list, toSection: 0)
                vc.dataSource.apply(snapshot)
            }
            .disposed(by: disposeBag)
        
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .map { notification in
                
            }
            .withUnretained(self)
            .bind { vc, _ in
                vc.searchButton.makeRound(radius: 0)
                vc.searchButton.snp.updateConstraints { make in
                    make.horizontalEdges.equalTo(vc.view.safeAreaLayoutGuide)
                    make.bottom.equalTo(vc.view.keyboardLayoutGuide.snp.top)
                }
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map { notification in
                
            }
            .withUnretained(self)
            .bind { vc, _ in
                vc.searchButton.makeRound(radius: 8)
                vc.searchButton.snp.updateConstraints { make in
                    make.horizontalEdges.equalTo(vc.view.safeAreaLayoutGuide).inset(Metric.margin)
                    make.bottom.equalTo(vc.view.keyboardLayoutGuide.snp.top).inset(-Metric.margin)
                }
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .asSignal()
            .emit(to: searchBar.rx.endEditing)
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .asSignal()
            .withUnretained(self)
            .emit(onNext: { vc, _ in
                guard let text = vc.searchBar.text else { return }
                if text.count < 1 || text.count > 8 {
                    vc.showToast(message: "최소 한 자 이상, 최대 8글자까지 작성 가능합니다")
                } else {
                    // 내가 하고 싶은 스터디에 추가
                    if vc.viewModel.selectedList.contains(text) {
                        // 만약 이미 추가된 요소라면?
                        vc.showToast(message: "이미 등록된 스터디입니다")
                    } else {
                        vc.viewModel.appendSelectedList(text)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        searchButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.viewModel.requestQueue(request: QueueRequest(lat: vc.mapLatitude, long: vc.mapLongitude, studyList: vc.viewModel.selectedRelay.value)) { statusCode in
                    if statusCode == 200 {
                        // 서버 통신 후 200이 왔을 때 > 화면 전환
                        let viewController = SearchSesacViewController()
                        viewController.mapLatitude = vc.mapLatitude
                        viewController.mapLongitude = vc.mapLongitude
                        vc.navigationController?.pushViewController(viewController, animated: true)
                    } else if statusCode == 201 {
                        vc.showToast(message: "신고가 누적되어 이용하실 수 없습니다.")
                    } else if statusCode == 203 {
                        vc.showToast(message: "스터디 취소 패널티로 1분동안 이용하실 수 없습니다.")
                    } else if statusCode == 204 {
                        vc.showToast(message: "스터디 취소 패널티로 2분동안 이용하실 수 없습니다.")
                    } else if statusCode == 205 {
                        vc.showToast(message: "스터디 취소 패널티로 3분동안 이용하실 수 없습니다.")
                    } else if statusCode == 401 {
                        vc.showToast(message: "토큰만료")
                    } else if statusCode == 406 {
                        vc.showToast(message: "미가입 회원")
                    } else if statusCode == 500 {
                        vc.showToast(message: "서버 내부 오류")
                    } else {
                        vc.showToast(message: "요청 값 부족")
                    }
                }
            })
            .disposed(by: disposeBag)

        viewModel.selectedRelay
            .withUnretained(self)
            .bind { vc, selectedList in
                if selectedList.count > 9 {
                    vc.showToast(message: "스터디를 더 이상 추가할 수 없습니다")
                } else {
                    vc.viewModel.makeSnapshot { sectionList in
                        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
                        
                        snapshot.appendSections([0, 1])
                        
                        snapshot.appendItems(sectionList[0], toSection: 0)
                        snapshot.appendItems(sectionList[1], toSection: 1)
                        vc.dataSource.apply(snapshot)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .map { indexPath in
                return (indexPath.section, indexPath.item)
            }
            .withUnretained(self)
            .subscribe { vc, indexPath in
                let section = indexPath.0
                let item = indexPath.1
                
                // TODO: - 0번째 선택하면 -> 1번째 섹션의 아이템에 추가 
                if section == 0 {
                    print("=============== 💨 0번째 Section - ", item)
                    
                } else {
                    print("=============== 💨 1번째 Section - ", item)
                    vc.viewModel.removeSelectedList(item)
                }
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
            item.edgeSpacing = .init(leading: .fixed(8), top: .fixed(8), trailing: .fixed(0), bottom: .fixed(8))
            
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
        let studyCellRegistration = UICollectionView.CellRegistration<StudyCollectionViewCell, String>.init { cell, indexPath, itemIdentifier in
            
            if indexPath.row < 4 {
                cell.type = .recommend
            } else {
                cell.type = .nearby
            }
            
            cell.title = itemIdentifier
        }
        
        let myStudyCellRegistration = UICollectionView.CellRegistration<MyStudyCollectionViewCell, String>.init { cell, indexPath, itemIdentifier in
            cell.type = .wantToDo
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
            if indexPath.section == 0 {
                let cell = collectionView.dequeueConfiguredReusableCell(using: studyCellRegistration, for: indexPath, item: itemIdentifier)
                return cell
            } else {
                let cell = collectionView.dequeueConfiguredReusableCell(using: myStudyCellRegistration, for: indexPath, item: itemIdentifier)
                return cell
            }
        })
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
    }
}
