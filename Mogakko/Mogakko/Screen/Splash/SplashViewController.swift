//
//  ViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/07.
//

import UIKit

import FirebaseAuth
import SnapKit
import Then

final class SplashViewController: UIViewController {
    
    // MARK: - UI Property
    
    private let logoImageView = UIImageView().then {
        $0.image = Constant.Image.splashLogo
        $0.contentMode = .scaleAspectFit
    }
    
    private let textImageView = UIImageView().then {
        $0.image = Constant.Image.splashText
        $0.contentMode = .scaleAspectFit
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureAttribute()
        presentFirstViewController()
    }
    
    func configureHierarchy() {
        view.addSubviews(logoImageView, textImageView)
        
        // TODO: - 이미지 크기 비율로 조정
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(216)
            make.width.equalTo(220)
            make.height.equalTo(264)
            make.centerX.equalToSuperview()
        }
        
        textImageView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(34)
            make.width.equalTo(328)
            make.height.equalTo(112)
            make.centerX.equalToSuperview()
        }
    }
    
    func configureAttribute() {
        view.backgroundColor = .white
    }
    
    private func presentFirstViewController() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            if UserDefaults.standard.bool(forKey: Constant.UserDefaults.isNotFirst) {
                
                if (UserDefaults.standard.string(forKey: Constant.UserDefaults.idtoken) != nil) {
                    self.checkIdToken()
                } else {
                    Helper.convertNavigationRootViewController(view: self.view, controller: PhoneNumberViewController())
                }
            } else {
                Helper.convertRootViewController(view: self.view, controller: OnboardingViewController())
            }
            
        }
    }
    
    private func checkIdToken() {
        // UserDefaults에 저장된 idToken을 기반으로 메모리스 서버와 통신
        UserAPI.shared.requestLogin { data, statusCode, error in
            guard let statusCode = statusCode else { return }
            print(statusCode)
            
            if statusCode == 200 {
                // 기존 사용자라면 -> 홈 화면으로
                guard let data = data else { return }
                print("🍀 사용자 정보 - \(data)")
                Helper.convertNavigationRootViewController(view: self.view, controller: TabBarViewController())
                
            } else if statusCode == 401 {
                // 토큰이 만료된 경우, 새로 토큰 발급
                print("💨 토큰 만료 !!! -> 다시 로그인 or 토근 새로 발급")
                
                let currentUser = Auth.auth().currentUser
                currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                    if let error = error {
                        print(error)
                    } else {
                        guard let idToken = idToken else { return }
                        print("✨ 새로 발급 받은 토큰 - \(idToken)")
                        UserDefaults.standard.set(idToken, forKey: Constant.UserDefaults.idtoken)

                        // TODO: - 토큰 재발급 이후 로직 구현
                        self.showToast(message: "에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
                    }
                }
                
            } else if statusCode == 406 {
                // 신규 사용자라면 -> 회원가입 화면으로
                Helper.convertNavigationRootViewController(view: self.view, controller: NicknameViewController())
            } else if statusCode == 500 {
                self.showToast(message: "서버 내부 오류입니다. 잠시 후 재인증 해주세요.")
            } else if statusCode == 501 {
                self.showToast(message: "Client Error")
            }
        }
    }
}
