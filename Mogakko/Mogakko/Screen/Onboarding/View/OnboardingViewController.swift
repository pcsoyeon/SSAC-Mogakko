//
//  OnboardingViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/07.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class OnboardingViewController: UIViewController {
    
    // MARK: - UI Property
    
    private let button = MDSButton().then {
        $0.type = .fill
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout).then {
        $0.isPagingEnabled = true
    }
    
    private var collectionLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }
    
    // MARK: - Property
    
    private let list: [Onboarding] = [Onboarding(title: "위치 기반으로 빠르게\n주위 친구를 확인", image: Constant.Image.onboardingImg1),
                                      Onboarding(title: "스터디를 원하는 친구를\n찾을 수 있어요", image: Constant.Image.onboardingImg2),
                                      Onboarding(title: "SeSAC Study", image: Constant.Image.onboardingImg3)]
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureAttribute()
        bind()
    }
}

extension OnboardingViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        view.addSubviews(collectionView, button)
        
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(56)
        }
        
        button.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(MDSButtonHeightType.h48.height)
        }
    }
    
    func configureAttribute() {
        view.backgroundColor = .white
        
        configureCollectionView()
        configureButton()
    }
    
    private func configureButton() {
        button.text = "시작하기"
    }
    
    private func configureCollectionView() {
        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCollectionViewCell.reuseIdentifier)
    }
    
    func bind() {
        let listObservable = Observable.of(list)
        listObservable.bind(to: collectionView.rx.items(cellIdentifier: OnboardingCollectionViewCell.reuseIdentifier, cellType: OnboardingCollectionViewCell.self)) { index, data, cell in
            cell.setData(title: data.title, image: data.image)
        }
        .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        button.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                let viewController = UINavigationController(rootViewController: AuthorizationViewController())
                viewController.modalPresentationStyle = .fullScreen
                viewController.modalTransitionStyle = .crossDissolve
                vc.present(viewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = view.frame.height
        return CGSize(width: width, height: height)
    }
}
