//
//  EmailViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/08.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class EmailViewController: UIViewController {
    
    // MARK: - UI Property
    
    private lazy var navigationBar = MDSNavigationBar(self).then {
        $0.backButtonIsHidden = false
    }
    
    private var titleLabel = UILabel().then {
        $0.text = "이메일을 입력해 주세요"
        $0.textColor = .black
        $0.font = MDSFont.Display1_R20.font
    }
    
    private var subtitleLabel = UILabel().then {
        $0.text = "휴대폰 번호 변경 시 인증을 위해 사용해요"
        $0.textColor = .gray7
        $0.font = MDSFont.Title2_R16.font
    }
    
    private var emailTextField = MDSInputTextField().then {
        $0.placeholder = "SeSAC@email.com"
        $0.tintColor = .green
        $0.type = .inactive
    }
    
    private var nextButton = MDSButton().then {
        $0.text = "다음"
        $0.type = .disable
        $0.heightType = .h48
    }
    
    // MARK: - Property
    
    private let viewModel = EmailViewModel()
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

extension EmailViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        view.addSubviews(navigationBar, titleLabel, subtitleLabel, emailTextField, nextButton)
        
        navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(97)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(63)
            make.horizontalEdges.equalToSuperview().inset(Metric.margin)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(72)
            make.horizontalEdges.equalToSuperview().inset(Metric.margin)
        }
    }
    
    func configureAttribute() {
        view.backgroundColor = .white
    }
    
    func bind() {
        let input = EmailViewModel.Input(emailTextFieldText: emailTextField.rx.text, buttonTap: nextButton.rx.tap)
        let output = viewModel.transform(from: input)
        
        emailTextField.rx.controlEvent([.editingChanged])
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.emailTextField.type = .focus
            })
            .disposed(by: disposeBag)
        
        output.buttonTap
            .withUnretained(self)
            .bind { vc, _ in
                if vc.viewModel.isValid.value {
                    guard let email = vc.emailTextField.text else { return }
                    UserDefaults.standard.set(email, forKey: "email")
                    
                    vc.navigationController?.pushViewController(GenderViewController(), animated: true)
                } else {
                    vc.showToast(message: "이메일 형식이 올바르지 않습니다.", font: MDSFont.Title4_R14.font)
                }
            }
            .disposed(by: disposeBag)
        
        output.buttonType
            .asDriver(onErrorJustReturn: .disable)
            .drive(onNext: { [weak self] type in
                guard let self = self else { return }
                self.nextButton.type = type
            })
            .disposed(by: disposeBag)
    }
}

