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
    
    private var cardView = CardView().then {
        $0.isExpanded = false
        $0.cardViewType = .info
    }
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
        networkMoniter()
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            make.bottom.equalToSuperview()
        }
    }
    
    func configureAttribute() {
        view.backgroundColor = .white
        configureContentView()
    }
    
    private func configureContentView() {
        contentStackView.addArrangedSubviews(cardView, genderView, studyView, allowSearchView, ageView, withdrawView)
    }
    
    func bind() {
        let input = InfoManagementViewModel.Input(viewWillAppear: rx.viewWillAppear, saveButtonTap: saveButton.rx.tap, expandButtonTap: cardView.expandButton.rx.tap, manButtonTap: genderView.manButton.rx.tap, womanButtonTap: genderView.womanButton.rx.tap, studyTextFieldText: studyView.textField.rx.text, searchSwithchIsOn: allowSearchView.switchButton.rx.isOn, withdrawTap: withdrawView.withdrawButton.rx.tap)
        
        let output = viewModel.transform(from: input)
        
        // 화면 전환 후, 데이터 받아서 -> UI 업데이트
        output.info
            .withUnretained(self)
            .bind { vc, data in
                vc.cardView.imageItem.accept(ImageItem(background: data.background, sesac: data.sesac))
                vc.cardView.cardItem.accept(CardItem(nickname: data.nick, reputation: data.reputation, comment: data.comment, studyList: [""]))
                vc.genderView.item = GenderItem(gender: data.gender)
                vc.studyView.item = StudyItem(study: data.study)
                vc.allowSearchView.item = AllowSearchItem(searchable: data.searchable)
                vc.ageView.item = AgeItem(ageMin: data.ageMin, ageMax: data.ageMax)
            }
            .disposed(by: disposeBag)
        
        // 저장 버튼
        output.saveButtonTap
            .withUnretained(self)
            .bind { vc, _ in
                vc.updateMypage()
            }
            .disposed(by: disposeBag)
        
        // 카드 뷰
        output.expandButtonTap
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.cardView.isExpanded.toggle()
            }
            .disposed(by: disposeBag)
        
        // 성별
        output.manButtonTap
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.genderView.manButton.type = .fill
                self.genderView.womanButton.type = .inactive
                
                self.viewModel.gender.accept(1)
            }
            .disposed(by: disposeBag)
        
        output.womanButtonTap
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.genderView.manButton.type = .inactive
                self.genderView.womanButton.type = .fill
                
                self.viewModel.gender.accept(0)
            }
            .disposed(by: disposeBag)
        
        // 스터디
        output.studyTextFieldText
            .withUnretained(self)
            .bind { vc, text in
                vc.viewModel.study.accept(text)
            }
            .disposed(by: disposeBag)
        
        // 검색허용
        output.searchSwithchIsOn
            .drive { [weak self] isOn in
                guard let self = self else { return }
                if isOn {
                    self.viewModel.allowSearch.accept(1)
                } else {
                    self.viewModel.allowSearch.accept(0)
                }
            }
            .disposed(by: disposeBag)
        
        // 상대방 연령대
        ageView.slider
            .addTarget(self, action: #selector(changeValue), for: .valueChanged)
        
        // 회원탈퇴
        output.withdrawTap
            .drive { [weak self] _ in
                guard let self = self else { return }
                let viewController = WithdrawPopupViewController()
                viewController.modalTransitionStyle = .crossDissolve
                viewController.modalPresentationStyle = .overFullScreen
                self.present(viewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - @objc
    
    @objc private func changeValue() {
        viewModel.ageMin.accept((Int(ageView.slider.lower)))
        viewModel.ageMax.accept((Int(ageView.slider.upper)))
    }
}

// MARK: - Network

extension InfoManagementViewController {
    private func updateMypage() {
        
        let param = MypageRequest(searchable: viewModel.allowSearch.value,
                                  ageMin: viewModel.ageMin.value,
                                  ageMax: viewModel.ageMax.value,
                                  gender: viewModel.gender.value,
                                  study: viewModel.study.value)
        let router = UserRouter.mypage(mypageRequest: param)
        
        GenericAPI.shared.requestData(router: router) { [weak self] response in
            guard let self = self else { return }
            
            switch response {
            case .success(_):
                self.showToast(message: "내 정보 업데이트!")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.navigationController?.popViewController(animated: true)
                }
                
            case .failure(let error):
                switch error {
                case .takenUser:
                    return
                case .invalidNickname:
                    return
                case .invalidAuthorization:
                    print("Firebase Token Error")
                case .unsubscribedUser:
                    Helper.convertNavigationRootViewController(view: self.view, controller: NicknameViewController())
                case .serverError:
                    print("서버 내부 에러")
                case .emptyParameters:
                    print("클라 요청 에러")
                }
            }
        }
    }
}
