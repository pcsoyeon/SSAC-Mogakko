//
//  WithdrawPopupViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/13.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class WithdrawPopupViewController: UIViewController {
    
    // MARK: - UI Property
    
    private var popupView = MDSPopupView().then {
        $0.title = "정말 탈퇴하시겠습니까?"
        $0.subtitle = "탈퇴하시면 새싹 스터디를 이용할 수 없어요ㅠ"
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureAttribute()
        bind()
    }
}

extension WithdrawPopupViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        view.addSubview(popupView)
        
        popupView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview()
        }
    }
    
    func configureAttribute() {
        view.backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    func bind() {
        popupView.addActionToButton { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        } comfirmCompletion: { [weak self] in
            guard let self = self else { return }
            self.requestWithdraw()
            Helper.convertNavigationRootViewController(view: self.view, controller: OnboardingViewController())
        }
    }
}

// MARK: - Network

extension WithdrawPopupViewController {
    private func requestWithdraw() {
        let router = UserRouter.withdraw
        GenericAPI.shared.requestData(router: router) { [weak self] response in
            guard let self = self else { return }
            
            switch response {
            case .success(_):
                self.showToast(message: "회원탈퇴 성공")
                
                for key in UserDefaults.standard.dictionaryRepresentation().keys {
                    UserDefaults.standard.removeObject(forKey: key.description)
                }
                
                UserDefaults.standard.set(false, forKey: Constant.UserDefaults.isNotFirst)
                Helper.convertRootViewController(view: self.view, controller: OnboardingViewController())
                
            case .failure(let error) :
                
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
