//
//  AuthorizationViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/07.
//

import UIKit

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
        numberTextField.rx.controlEvent([.editingChanged])
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.numberTextField.type = .focus
            })
            .disposed(by: disposeBag)
        
        numberTextField.rx.text
            .withUnretained(self)
            .bind { vc, text in
                guard let text = text else { return }
                vc.viewModel.phoneNumber.accept(text)
                vc.viewModel.changePhoneNumber(text)
            }
            .disposed(by: disposeBag)
        
        viewModel.phoneNumber
            .bind(to: numberTextField.rx.text)
            .disposed(by: disposeBag)
            
        viewModel.isValid
            .bind(to: button.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isValid
            .map { $0 ? UIColor.green : UIColor.gray6 }
            .bind(to: button.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel.isValid
            .withUnretained(self)
            .bind { vc, value in
                if value {
                    vc.numberTextField.type = .active
                }
            }
            .disposed(by: disposeBag)
    }
}
