//
//  GenderViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/08.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

enum Gender {
    case man
    case woman
    
    var image: UIImage {
        switch self {
        case .man:
            return Constant.Image.man
        case .woman:
            return Constant.Image.woman
        }
    }
    
    var text: String {
        switch self {
        case .man:
            return "남자"
        case .woman:
            return "여자"
        }
    }
}

final class GenderViewController: UIViewController {
    
    // MARK: - UI Property
    
    private lazy var navigationBar = MDSNavigationBar(self).then {
        $0.backButtonIsHidden = false
    }
    
    private var titleLabel = UILabel().then {
        $0.text = "성별을 선택해 주세요"
        $0.textColor = .black
        $0.font = MDSFont.Display1_R20.font
    }
    
    private var subtitleLabel = UILabel().then {
        $0.text = "새싹 찾기 기능을 이용하기 위해서 필요해요!"
        $0.textColor = .gray7
        $0.font = MDSFont.Title2_R16.font
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout).then {
        $0.isScrollEnabled = false
    }
    
    private var collectionLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }
    
    private var nextButton = MDSButton().then {
        $0.text = "다음"
        $0.type = .disable
        $0.heightType = .h48
    }
    
    // MARK: - Property

    private let viewModel = GenderViewModel()
    
    private let disposeBag = DisposeBag()
    
    private let gender = [Gender.man, Gender.woman]
    
    private var selected = false
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        networkMoniter()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureAttribute()
        bind()
    }
    
}

extension GenderViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        view.addSubviews(navigationBar, titleLabel, subtitleLabel, collectionView, nextButton)
        
        navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(80)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(120)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(Metric.margin)
        }
    }
    
    func configureAttribute() {
        view.backgroundColor = .white
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.register(GenderCollectionViewCell.self, forCellWithReuseIdentifier: GenderCollectionViewCell.reuseIdentifier)
    }
    
    func bind() {
        let listObservable = Observable.of(gender)
        listObservable.bind(to: collectionView.rx.items(cellIdentifier: GenderCollectionViewCell.reuseIdentifier, cellType: GenderCollectionViewCell.self)) { index, data, cell in
            if index == 0 {
                cell.setData(Gender.man)
            } else {
                cell.setData(Gender.woman)
            }
        }
        .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .asDriver()
            .drive { [weak self] indexPath in
                guard let self = self else { return }
                
                if indexPath.row == 0 {
                    UserDefaults.standard.set(1, forKey: Constant.UserDefaults.gender)
                } else {
                    UserDefaults.standard.set(0, forKey: Constant.UserDefaults.gender)
                }
                
                self.selected = true
                self.nextButton.type = .fill
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                
                if vc.selected {
                    
                    vc.viewModel.requestSignup { statusCode in
                        if statusCode == 200 {
                            print("🍋 홈 화면으로 이동")
                            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                            let sceneDelegate = windowScene?.delegate as? SceneDelegate
                            
                            sceneDelegate?.window?.rootViewController = UINavigationController(rootViewController: TabBarViewController())
                            sceneDelegate?.window?.makeKeyAndVisible()
                            
                        } else if statusCode == 201 {
                            print("🍋 이미 가입한 유저 -> 로그인 화면으로 이동")
                            vc.showToast(message: "이미 가입한 유저입니다.")
                        } else if statusCode == 202 {
                            print("🍋 사용할 수 없는 닉네임 -> 닉네임 화면으로 이동")
                            
                            // 닉네임 화면까지 pop
                            vc.popToNicknameView()
                            
                        } else if statusCode == 401 {
                            print("🍋 Firebase Token Error")
                        } else if statusCode == 500 {
                            print("🍋 Server Error")
                        } else if statusCode == 501 {
                            print("🍋 Header와 RequestBody에 값 확인")
                        }
                    }
                    
                } else {
                    vc.showToast(message: "성별을 선택해주세요.")
                }
                

            }
            .disposed(by: disposeBag)
    }
    
    private func popToNicknameView() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
    }
}

extension GenderViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 16 - 16 - 12) / 2
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

