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
        GenericAPI.shared.requestDecodableData(type: Login.self, router: UserRouter.login) { [weak self] response in
            guard let self = self else { return }
            
            switch response {
            case .success(let data):
                print("🍀 사용자 정보 \(data)")
                Helper.convertNavigationRootViewController(view: self.view, controller: TabBarViewController())
                
            case .failure(let error):
                switch error {
                case .takenUser, .invalidNickname:
                    return
                case .invalidAuthorization:
                    Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                        if let error = error {
                            print(error)
                        }
                        
                        if let idToken = idToken {
                            print("✨ 새로 발급 받은 토큰 - \(idToken)")
                            self.refreshToken(idToken: idToken)
                        }
                    }
                case .unsubscribedUser:
                    Helper.convertNavigationRootViewController(view: self.view, controller: NicknameViewController())
                case .serverError:
                    self.showToast(message: "서버 내부 오류입니다. 잠시 후 재인증 해주세요.")
                case .emptyParameters:
                    self.showToast(message: "Client Error")
                }
                
            }
        }
    }
    
    private func refreshToken(idToken: String) {
        UserDefaults.standard.removeObject(forKey: Constant.UserDefaults.idtoken)
        UserDefaults.standard.set(idToken, forKey: Constant.UserDefaults.idtoken)
        
        GenericAPI.shared.requestDecodableData(type: Login.self, router: UserRouter.login) { response in
            switch response {
            case .success(let success):
                print("🍀 사용자 정보 - \(success)")
                Helper.convertNavigationRootViewController(view: self.view, controller: TabBarViewController())
            case .failure(let failure):
                print("🔥 재발급 이후 Error - \(failure)")
            }
        }
    }
}
