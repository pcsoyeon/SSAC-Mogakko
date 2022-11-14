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
    
    private var withdrawButton = UIButton().then {
        $0.setTitle("회원탈퇴", for: .normal)
        $0.setTitleColor(.green, for: .normal)
    }
    
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
        configureHierarchy()
        configureAttribute()
        bind()
    }
}

extension InfoManagementViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        view.addSubviews(navigationBar, withdrawButton)
        navigationBar.addSubview(saveButton)
        
        navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        saveButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(Metric.margin)
        }
        
        withdrawButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func configureAttribute() {
        view.backgroundColor = .white
    }
    
    func bind() {
        saveButton.rx.tap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { vc, _ in
                vc.updateMypage()
            }
            .disposed(by: disposeBag)
        
        withdrawButton.rx.tap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { vc, _ in
                let viewController = WithdrawPopupViewController()
                viewController.modalTransitionStyle = .crossDissolve
                viewController.modalPresentationStyle = .overFullScreen
                vc.present(viewController, animated: true)
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
