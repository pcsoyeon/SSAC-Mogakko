//
//  InfoManangementViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/13.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class InfoManagementViewController: UIViewController {
    
    // MARK: - UI Property
    
    private lazy var navigationBar = MDSNavigationBar(self).then {
        $0.backButtonIsHidden = false
        $0.title = "정보 관리"
    }
    
    private var saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = MDSFont.Title3_M14.font
    }
    
    private lazy var scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
        $0.contentInsetAdjustmentBehavior = .never
    }
    
    private lazy var contentView = UIView()
    
    private lazy var contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .fill
        $0.spacing = 16
    }
    
    private var imageView = InfoImageView()
    private var cardView = CardView()
    private var genderView = GenderView()
    private var studyView = StudyView()
    private var allowSearchView = AllowSearchView()
    private var ageView = AgeView()
    private var withdrawView = WithdrawView()
    
    // MARK: - Property
    
    private let viewModel = InfoManagementViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setItem()
        
        configureHierarchy()
        configureAttribute()
        bind()
    }
}

extension InfoManagementViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        view.addSubviews(navigationBar, scrollView)
        navigationBar.addSubview(saveButton)
        scrollView.addSubview(contentView)
        contentView.addSubview(contentStackView)
        
        navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        saveButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(Metric.margin)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    func configureAttribute() {
        view.backgroundColor = .white
        
        configureContentView()
        setItem()
    }
    
    private func configureContentView() {
        contentStackView.addArrangedSubviews(cardView, genderView, studyView, allowSearchView, ageView, withdrawView)
    }
    
    private func setItem() {
        let image = ImageItem(background: 1, sesac: 1)
        let card = CardItem(nickname: UserDefaults.standard.string(forKey: Constant.UserDefaults.nick)!, review: "악으로깡으로해냅니다김소연이죠?")
        let gender = GenderItem(gender: 0)
        let study = StudyItem(study: "알고리즘")
        let allow = AllowSearchItem(searchable: 1)
        let age = AgeItem(ageMin: 18, ageMax: 35)
        let withdraw = WithdrawItem()
        
        cardView.imageItem = image
        cardView.cardItem = card
        genderView.item = gender
        studyView.item = study
        allowSearchView.item = allow
        ageView.item = age
        withdrawView.item = withdraw
        
        cardView.isExpanded = false
    }
    
    func bind() {
        saveButton.rx.tap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { vc, _ in
                vc.updateMypage()
            }
            .disposed(by: disposeBag)
        
        cardView.expandButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.cardView.isExpanded.toggle()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Network

extension InfoManagementViewController {
    private func updateMypage() {
        let param = MypageRequest(searchable: 1, ageMin: 20, ageMax: 35, gender: 0, study: "Jack&Hue \(Int.random(in: 1...100))")
        let router = UserRouter.mypage(mypageRequest: param)
        
        GenericAPI.shared.requestData(router: router) { [weak self] response in
            guard let self = self else { return }
            
            switch response {
            case .success(_):
                self.showToast(message: "내 정보 업데이트!")
                self.navigationController?.popViewController(animated: true)
                
            case .failure(let error):
                switch error {
                case .takenUser:
                    return
                case .invalidNickname:
                    return
                case .invalidAuthorization:
                    print("Firebase Token Error")
                case .unsubscribedUser:
                    print("미가입 회원/탈퇴 성공")
                case .serverError:
                    print("서버 내부 에러")
                case .emptyParameters:
                    print("클라 요청 에러")
                }
            }
        }
    }
}
