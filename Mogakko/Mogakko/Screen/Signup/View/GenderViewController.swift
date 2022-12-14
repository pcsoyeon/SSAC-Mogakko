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
            cell.setData(data)
        }
        .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .asDriver()
            .drive { [weak self] indexPath in
                guard let self = self else { return }
                
                if indexPath.row == 0 {
                    UserData.gender = 1
                } else {
                    UserData.gender = 0
                }
                
                self.selected = true
                self.nextButton.type = .fill
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .throttle(.seconds(5), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { vc, _ in
                
                if vc.selected {
                    
                    vc.viewModel.requestSignup { statusCode in
                        if statusCode == 200 {
                            Helper.convertNavigationRootViewController(view: vc.view, controller: TabBarViewController())
                        } else if statusCode == 201 {
                            vc.showToast(message: "이미 가입한 유저입니다.")
                            Helper.convertNavigationRootViewController(view: vc.view, controller: PhoneNumberViewController())
                        } else if statusCode == 202 {
                            vc.showToast(message: "사용할 수 없는 닉네임입니다.")
                            vc.popToNicknameView()
                        } else if statusCode == 401 {
                            vc.showToast(message: "만료된 토큰입니다.")
                        } else if statusCode == 500 {
                            vc.showToast(message: "서버 에러입니다. 잠시 후 이용해주세요.")
                        } else if statusCode == 501 {
                            vc.showToast(message: "request header/body를 확인해주세요.")
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

