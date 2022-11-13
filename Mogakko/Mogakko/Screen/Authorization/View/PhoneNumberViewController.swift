//
//  AuthorizationViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/07.
//

import UIKit

import FirebaseAuth
import RxCocoa
import RxSwift
import SnapKit
import Then

final class PhoneNumberViewController: UIViewController {
    
    // MARK: - UI Property
    
    private var titleLabel = UILabel().then {
        $0.text = """
                  새싹 서비스 이용을 위해
                  휴대폰 번호를 입력해주세요
                  """
        $0.textAlignment = .center
        $0.font = MDSFont.Display1_R20.font
        $0.numberOfLines = 2
    }
    
    private var numberTextField = MDSInputTextField().then {
        $0.type = .inactive
        $0.placeholder = "휴대폰 번호(-없이 숫자만 입력)"
        $0.keyboardType = .numberPad
        $0.tintColor = .green
    }
    
    private var button = MDSButton().then {
        $0.type = .disable
        $0.text = "인증 문자 받기"
        $0.heightType = .h48
    }
    
    // MARK: - Property
    
    private let viewModel = PhoneNumberViewModel()
    
    private let disposeBag = DisposeBag()
    
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

extension PhoneNumberViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        view.addSubviews(titleLabel, numberTextField, button)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(125)
            make.centerX.equalToSuperview()
        }
        
        numberTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(77)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(numberTextField.snp.bottom).offset(72)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    func configureAttribute() {
        view.backgroundColor = .white
    }
    
    func bind() {
        let input = PhoneNumberViewModel.Input(numberTextFieldText: numberTextField.rx.text, buttonTap: button.rx.tap)
        
        let output = viewModel.transform(from: input)
        
        numberTextField.rx.controlEvent([.editingChanged])
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.numberTextField.type = .focus
            })
            .disposed(by: disposeBag)
        
        output.buttonTap
            .throttle(.seconds(5), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { vc, _ in
                
                guard let phonNumber = vc.numberTextField.text else { return }
                
                if phonNumber.count >= 12 {
                    
                    vc.showToast(message: "전화 번호 인증 시작")
                    
                    vc.viewModel.requestVerificationCode(phoneNumber: phonNumber) { [weak self] verificationID, error in
                        guard let self = self else { return }
                        guard let verificationID = verificationID else { return }
                        
                        if let error = error as NSError? {
                            guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else { return }
                            switch errorCode {
                            case .tooManyRequests:
                                self.showToast(message: "과도한 인증 시도가 있었습니다. 나중에 다시 시도해 주세요.")
                            default:
                                self.showToast(message: "에러가 발생했습니다. 다시 시도해주세요.")
                            }
                        }
                        
                        print("🟢 Vertification ID : \(verificationID)")
                        
                        let viewController = CertificationNumberViewController()
                        viewController.verificationID = verificationID
                        vc.navigationController?.pushViewController(viewController, animated: true)
                    }
                    
                } else {
                    vc.showToast(message: "잘못된 전화번호 형식입니다.")
                }
            }
            .disposed(by: disposeBag)
        
        output.phoneNumber
            .bind(to: numberTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.isValid
            .map { $0 ? MDSButtonType.fill : MDSButtonType.disable }
            .emit(to: button.rx.type)
            .disposed(by: disposeBag)
        
        output.isValid
            .withUnretained(self)
            .emit { vc, value in
                if value {
                    vc.numberTextField.type = .active
                }
            }
            .disposed(by: disposeBag)
    }
}
