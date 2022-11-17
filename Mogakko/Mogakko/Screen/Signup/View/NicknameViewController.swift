//
//  NicknameViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/08.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class NicknameViewController: UIViewController {
    
    // MARK: - UI Property
    
    private lazy var navigationBar = MDSNavigationBar(self).then {
        $0.backButtonIsHidden = false
    }
    
    private var titleLabel = UILabel().then {
        $0.text = "닉네임을 입력해주세요"
        $0.textColor = .black
        $0.font = MDSFont.Display1_R20.font
    }
    
    private var nicknameTextField = MDSInputTextField().then {
        $0.placeholder = "10자 이내로 입력"
        $0.tintColor = .green
        $0.type = .inactive
        $0.becomeFirstResponder()
    }
    
    private var nextButton = MDSButton().then {
        $0.text = "다음"
        $0.type = .disable
        $0.heightType = .h48
    }
    
    // MARK: - Property
    
    private let viewModel = NicknameViewModel()
    
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

extension NicknameViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        view.addSubviews(navigationBar, titleLabel, nicknameTextField, nextButton)
        
        navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(97)
            make.centerX.equalToSuperview()
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(80)
            make.horizontalEdges.equalToSuperview().inset(Metric.margin)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(72)
            make.horizontalEdges.equalToSuperview().inset(Metric.margin)
        }
    }
    
    func configureAttribute() {
        view.backgroundColor = .white
    }
    
    func bind() {
        let input = NicknameViewModel.Input(nicknameTextFieldText: nicknameTextField.rx.text, buttonTap: nextButton.rx.tap)
        let output = viewModel.transform(from: input)
        
        nicknameTextField.rx.controlEvent([.editingChanged])
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.nicknameTextField.type = .focus
            })
            .disposed(by: disposeBag)
        
        output.buttonType
            .bind(to: nextButton.rx.type)
            .disposed(by: disposeBag)
        
        output.nicknameTextFieldSignal
            .emit(onNext: { [weak self] value in
                guard let self = self else { return }
                if !value {
                    self.nicknameTextField.text = String(self.nicknameTextField.text?.dropLast() ?? "")
                }
            })
            .disposed(by: disposeBag)
        
        output.buttonTap
            .withUnretained(self)
            .bind { vc, _ in
                guard let nick = vc.nicknameTextField.text else { return }
                
                if nick.count >= 1 && nick.count <= 10 {
                    UserData.nickName = nick
                    vc.navigationController?.pushViewController(BirthViewController(), animated: true)
                } else {
                    vc.showToast(message: "닉네임은 1자 이상 10자 이내로 부탁드려요.")
                }
                
            }
            .disposed(by: disposeBag)
    }
}
