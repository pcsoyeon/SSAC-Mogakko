//
//  ViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/07.
//

import UIKit

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
    
    func presentFirstViewController() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            if UserDefaults.standard.bool(forKey: Constant.UserDefaults.isNotFirst) {
                let viewController = UINavigationController(rootViewController: PhoneNumberViewController())
                viewController.modalTransitionStyle = .crossDissolve
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true)
            } else {
                let viewController = OnboardingViewController()
                viewController.modalTransitionStyle = .crossDissolve
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true)
            }
        }
        
    }
}
