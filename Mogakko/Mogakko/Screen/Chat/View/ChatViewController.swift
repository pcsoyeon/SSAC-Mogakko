//
//  ChatViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/21.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class ChatViewController: UIViewController {
    
    // MARK: - UI Property
    
    private lazy var navigationBar = MDSNavigationBar(self).then {
        $0.backButtonIsHidden = true
        $0.addSubviews(backButton, moreButton)
    }
    
    private var backButton = UIButton().then {
        $0.setImage(Constant.Image.arrow, for: .normal)
        $0.isHidden = false
    }
    
    private var moreButton = UIButton().then {
        $0.setImage(Constant.Image.more, for: .normal)
    }
    
    // MARK: - Property
    
    let viewModel = ChatViewModel()
    private let disposeBag = DisposeBag()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureAttribute()
        bind()
    }
}

extension ChatViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        view.addSubviews(navigationBar)
        
        navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(Metric.margin)
        }
        
        moreButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(Metric.margin)
        }
    }
    
    func configureAttribute() {
        view.backgroundColor = .white
    }
    
    func bind() {
        viewModel.queue
            .withUnretained(self)
            .bind { vc, queue in
                vc.navigationBar.title = queue.nick
            }
            .disposed(by: disposeBag)
        
        viewModel.nick
            .withUnretained(self)
            .bind { vc, nick in
                vc.navigationBar.title = nick
            }
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .withUnretained(self)
            .bind { _ in
                self.navigationController?.popToRootViewController(animated: false)
            }
            .disposed(by: disposeBag)
    }
}
