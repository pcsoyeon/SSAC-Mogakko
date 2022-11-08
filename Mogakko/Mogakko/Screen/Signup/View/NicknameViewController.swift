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
    }
    
    private var nextButton = MDSButton().then {
        $0.text = "다음"
        $0.type = .disable
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
        nicknameTextField.rx.controlEvent([.editingChanged])
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.nicknameTextField.type = .focus
            })
            .disposed(by: disposeBag)
        
        nicknameTextField.rx.text.orEmpty
            .map { $0.count <= 10 && $0.count > 0 }
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        nicknameTextField.rx.text.orEmpty
            .map { $0.count <= 10 && $0.count > 0 ? MDSButtonType.fill : MDSButtonType.disable}
            .bind(to: nextButton.rx.type)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.navigationController?.pushViewController(BirthViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
}