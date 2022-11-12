//
//  HomeViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/11.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

class HomeViewController: UIViewController {

    // MARK: - UI Property
    
    private var withdrawButton = UIButton().then {
        $0.setTitle("탈퇴하기", for: .normal)
        $0.setTitleColor(.lightGray, for: .normal)
    }
    
    private var floatingButton = MDSFloatingButton().then {
        $0.type = .plain
    }
    
    // MARK: - Property
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        networkMoniter()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAttribute()
        configureHierarchy()
        bind()
    }
}

extension HomeViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        view.addSubviews(withdrawButton, floatingButton)
        withdrawButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        floatingButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(Metric.margin)
        }
    }
    
    func configureAttribute() {
        view.backgroundColor = .darkGray
    }
    
    func bind() {
        withdrawButton.rx.tap
            .bind {
                UserAPI.shared.requestWithdraw { statusCode, error in
                    guard let statusCode = statusCode else { return }
                    print(statusCode)
                    if statusCode == 200 {
                        print("회원탈퇴 성공")
                        
                        // UserDefaults 값 초기화
                        for key in UserDefaults.standard.dictionaryRepresentation().keys {
                            UserDefaults.standard.removeObject(forKey: key.description)
                        }
                        
                        // Onboarding부터 시작할 수 있도록
                        UserDefaults.standard.set(false, forKey: Constant.UserDefaults.isNotFirst)
                        Helper.convertRootViewController(view: self.view, controller: OnboardingViewController())
                        
                    } else if statusCode == 401 {
                        print("Firebase Token Error")
                    } else if statusCode == 406 {
                        print("이미 탈퇴된 회원/미가입 회원")
                    } else if statusCode == 500 {
                        print("Server Error")
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    
}
