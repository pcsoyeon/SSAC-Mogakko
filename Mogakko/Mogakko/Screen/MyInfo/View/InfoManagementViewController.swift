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
                let param = MypageRequest(searchable: 1, ageMin: 20, ageMax: 25, gender: 0, study: "Jack&Hue")
                
                UserAPI.shared.requestMypage(mypage: param) { statusCode, error in
                    guard let statusCode = statusCode else { return }
                    guard let error = error else { return }
                    
                    print("🥑 정보 관리 업데이트 -> 상태코드 : \(statusCode) / 에러 : \(error.localizedDescription)")
                    
                    DispatchQueue.main.async {
                        vc.showToast(message: "내 정보 업데이트!")
                        vc.navigationController?.popViewController(animated: true)
                    }
                    
                }
                
            }
            .disposed(by: disposeBag)
        
        withdrawButton.rx.tap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { vc, _ in
                
                UserAPI.shared.requestWithdraw { statusCode, error in
                    guard let statusCode = statusCode else { return }
                    guard let error = error else { return }
                    
                    print("🥑 회원탈퇴 -> 상태코드 : \(statusCode) / 에러 : \(error.localizedDescription)")
                    
                    if statusCode == 200 {
                        DispatchQueue.main.async {
                            vc.showToast(message: "회원탈퇴 성공")
                            
                            // UserDefaults 값 초기화
                            for key in UserDefaults.standard.dictionaryRepresentation().keys {
                                UserDefaults.standard.removeObject(forKey: key.description)
                            }
                            
                            // Onboarding부터 시작할 수 있도록
                            UserDefaults.standard.set(false, forKey: Constant.UserDefaults.isNotFirst)
                            Helper.convertRootViewController(view: self.view, controller: OnboardingViewController())
                        }
                        
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
