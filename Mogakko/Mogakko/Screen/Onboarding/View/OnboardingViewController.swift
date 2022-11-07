//
//  OnboardingViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/07.
//

import UIKit

import SnapKit
import Then

final class OnboardingViewController: UIViewController {
    
    // MARK: - UI Property
    
    private let button = MDSButton().then {
        $0.type = .fill
    }
    
    private let textField = MDSInputTextField().then {
        $0.text = "메시지를 입력"
        $0.type = .active
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        setAttribute()
        bind()
    }
}

extension OnboardingViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        view.addSubviews(button)
        
        button.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(MDSButtonHeightType.h48.height)
        }
    }
    
    func setAttribute() {
        view.backgroundColor = .white
        
        button.text = "시작하기"
    }
    
    func bind() {
        
    }
}
