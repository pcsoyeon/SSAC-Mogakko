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

import FirebaseMessaging

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
    
    // MARK: - Property
    
    private let list: [Onboarding] = [Onboarding(title: "위치 기반으로 빠르게\n주위 친구를 확인", image: Constant.Image.onboardingImg1),
                                      Onboarding(title: "스터디를 원하는 친구를\n찾을 수 있어요", image: Constant.Image.onboardingImg2),
                                      Onboarding(title: "SeSAC Study", image: Constant.Image.onboardingImg3)]
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.string(forKey: Constant.UserDefaults.FCMtoken) == nil {
            print("💨 갱신을 한다???????")
            Messaging.messaging().delegate = self
            
            Messaging.messaging().token { token, error in
                if let error = error {
                    print("Error fetching FCM registration token: \(error)")
                } else if let token = token {
                    print("FCM registration token: \(token)")
                    UserDefaults.standard.set(token, forKey: Constant.UserDefaults.FCMtoken)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureAttribute()
        bind()
    }
}

extension OnboardingViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        view.addSubviews(collectionView, pageControl, button)
        
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(564)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(button.snp.top).inset(-42)
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
            cell.setData(title: data.title, image: data.image, index: index)
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
            .throttle(.seconds(5), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { vc, _ in
                UserDefaults.standard.set(true, forKey: Constant.UserDefaults.isNotFirst)
                
                let viewController = UINavigationController(rootViewController: PhoneNumberViewController())
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

// MARK: - Update FCM

extension OnboardingViewController: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        guard let fcmToken = fcmToken else { return }
        UserDefaults.standard.set(fcmToken, forKey: Constant.UserDefaults.FCMtoken)
    }
}
