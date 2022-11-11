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
        $0.heightType = .h48
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout).then {
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
    }
    
    private var collectionLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }
    
    private var pageControl = UIPageControl().then {
        $0.numberOfPages = 3
        $0.pageIndicatorTintColor = .gray5
        $0.currentPageIndicatorTintColor = .black
    }
    
    // MARK: - TODO REMOVE
    
    private var withdrawButton = UIButton().then {
        $0.setTitle("탈퇴하기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
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
        view.addSubviews(collectionView, pageControl, button, withdrawButton)
        
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(564)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(button.snp.top).inset(-42)
        }
        
        withdrawButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(70)
        }
        
        button.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
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
        
        collectionView.rx.contentOffset
            .map { $0.x }
            .withUnretained(self)
            .bind { vc, point in
                vc.pageControl.currentPage = Int(round(point / max(1, vc.collectionView.bounds.width)))
            }
            .disposed(by: disposeBag)
        
        button.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                let viewController = UINavigationController(rootViewController: PhoneNumberViewController())
                viewController.modalPresentationStyle = .fullScreen
                viewController.modalTransitionStyle = .crossDissolve
                vc.present(viewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        withdrawButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                UserAPI.shared.requestWithdraw { statusCode, error in
                    print("😫 회원 탈퇴 statusCode : \(statusCode)")
                    
                    if statusCode == 200 {
                        print("회원 가입 탈퇴 성공")
                    } else if statusCode == 401 {
                        print("Firebase Token Error")
                    } else if statusCode == 406 {
                        print("탈퇴 처리된 회원(미가입 회원)")
                    } else {
                        print("Server Error")
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = 564.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
