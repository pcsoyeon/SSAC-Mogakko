//
//  CertificationNumberViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/08.
//

import UIKit

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
        numberTextField.rx.controlEvent([.editingChanged])
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.numberTextField.type = .focus
            })
            .disposed(by: disposeBag)
        
        numberTextField.rx.text.orEmpty
            .map { $0.count <= 6 && $0.count >= 0 }
            .bind(to: resendButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        numberTextField.rx.text.orEmpty
            .map { $0.count <= 6 && $0.count >= 0 ? MDSButtonType.fill : MDSButtonType.disable}
            .bind(to: startButton.rx.type)
            .disposed(by: disposeBag)
    }
}
