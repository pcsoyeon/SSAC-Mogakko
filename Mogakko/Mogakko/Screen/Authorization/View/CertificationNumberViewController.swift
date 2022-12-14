//
//  CertificationNumberViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/08.
//

import UIKit

import FirebaseAuth
import RxCocoa
import RxSwift
import SnapKit
import Then

final class CertificationNumberViewController: UIViewController {
    
    // MARK: - UI Property
    
    private lazy var navigationBar = MDSNavigationBar(self).then {
        $0.backButtonIsHidden = false
    }
    
    private var titleLabel = UILabel().then {
        $0.text = "인증번호가 문자로 전송되었어요."
        $0.font = MDSFont.Display1_R20.font
        $0.textColor = .black
    }
    
    private var timerLabel = UILabel().then {
        $0.textColor = .green
        $0.font = MDSFont.Title3_M14.font
        $0.text = "01:00"
    }
    
    private var numberTextField = MDSInputTextField().then {
        $0.type = .inactive
        $0.placeholder = "인증번호 입력"
        $0.keyboardType = .numberPad
        $0.tintColor = .green
    }
    
    private var resendButton = MDSButton().then {
        $0.type = .fill
        $0.text = "재전송"
        $0.heightType = .h40
    }
    
    private var startButton = MDSButton().then {
        $0.type = .disable
        $0.text = "인증하고 시작하기"
        $0.heightType = .h48
    }
    
    // MARK: - Property
    
    private let disposeBag = DisposeBag()
    
    var verificationID: String = ""
    private let viewModel = CertificationNumberViewModel()
    
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

extension CertificationNumberViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        view.addSubviews(navigationBar, titleLabel, numberTextField, resendButton, startButton)
        numberTextField.addSubview(timerLabel)
        
        navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(124)
            make.centerX.equalToSuperview()
        }
        
        numberTextField.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(Metric.margin)
            make.top.equalTo(titleLabel.snp.bottom).offset(97)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(96)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.verticalEdges.equalToSuperview().inset(13)
        }
        
        resendButton.snp.makeConstraints { make in
            make.centerY.equalTo(numberTextField.snp.centerY)
            make.leading.equalTo(numberTextField.snp.trailing).offset(8)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(Metric.margin)
        }
        
        startButton.snp.makeConstraints { make in
            make.top.equalTo(numberTextField.snp.bottom).offset(72)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(Metric.margin)
        }
    }
    
    func configureAttribute() {
        view.backgroundColor = .white
    }
    
    func bind() {
        let input = CertificationNumberViewModel.Input(numberTextFieldText: numberTextField.rx.text, buttonTap: startButton.rx.tap)
        let output = viewModel.transform(from: input)
        
        numberTextField.rx.controlEvent([.editingChanged])
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.numberTextField.type = .focus
            })
            .disposed(by: disposeBag)
        
        output.startButtonType
            .bind(to: startButton.rx.type)
            .disposed(by: disposeBag)
        
        output.numberTextFieldSignal
            .emit(onNext: { [weak self] value in
                guard let self = self else { return }
                if !value {
                    self.numberTextField.text = String(self.numberTextField.text?.dropLast() ?? "")
                }
            })
            .disposed(by: disposeBag)
        
        output.buttonTap
            .throttle(.seconds(5), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { vc, _ in
                
                guard let verificationCode = vc.numberTextField.text else { return }
                
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: vc.verificationID, verificationCode: verificationCode)
                
                Auth.auth().signIn(with: credential) { result, error in
                    
                    if let error = error {
                        print("🔥 Fail to Signin with Firebase : \(error.localizedDescription)")
                        vc.showToast(message: "전화 번호 인증 실패")
                    } else {
                        print("🌊 인증번호 일치 -> Firebase idToken 요청")
                        
                        result?.user.getIDToken { idToken, error in
                            guard let idToken = idToken else { return }
                            print("✨ 발급 받은 토큰 - \(idToken)")
                            
                            UserData.idtoken = idToken
                            self.requestLogin()
                        }
                        
                    }
                }
                
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Network
    
    private func requestLogin() {
        
        let router = UserRouter.login
        GenericAPI.shared.requestDecodableData(type: Login.self, router: router) { [weak self] response in
            guard let self = self else { return }
            
            switch response {
            case .success(let data):
                print("🍀 사용자 정보 \(data)")
                Helper.convertNavigationRootViewController(view: self.view, controller: TabBarViewController())
            case .failure(let error):
                switch error {
                case .takenUser:
                    return
                case .invalidNickname:
                    return
                case .invalidAuthorization:
                    UserAPI.shared.refreshIdToken { result in
                        switch result {
                        case .success(let idtoken):
                            print("갱신 - ", UserData.idtoken)
                            self.refreshToken(idtoken)
                            
                        case .failure(let error):
                            print(error.localizedDescription)
                            return
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
    
    private func refreshToken(_ idtoken: String) {
        GenericAPI.shared.requestDecodableData(type: Login.self, router: UserRouter.refresh(idToken: idtoken)) { response in
            switch response {
            case .success(let data):
                UserData.nickName = data.nick
                Helper.convertNavigationRootViewController(view: self.view, controller: TabBarViewController())
            case .failure(_):
                self.showToast(message: "토큰 갱신 오류입니다. 잠시 후 다시 시도해주세요.")
            }
        }
    }
}
