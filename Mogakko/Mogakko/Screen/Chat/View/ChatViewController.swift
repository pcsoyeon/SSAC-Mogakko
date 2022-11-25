//
//  ChatViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/21.
//

import UIKit

import RxCocoa
import RxDataSources
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
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = UITableView.automaticDimension
        
        $0.separatorStyle = .none
        
        $0.register(HeaderTableViewCell.self, forCellReuseIdentifier: HeaderTableViewCell.reuseIdentifier)
        $0.register(MyBubbleTableViewCell.self, forCellReuseIdentifier: MyBubbleTableViewCell.reuseIdentifier)
        $0.register(OtherBubbleTableViewCell.self, forCellReuseIdentifier: OtherBubbleTableViewCell.reuseIdentifier)
    }
    
    private var menuView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var messageTextView = UITextView().then {
        $0.text = "메세지를 입력하세요"
        $0.textColor = .gray7
        $0.font = MDSFont.Body3_R14.font
        $0.backgroundColor = .gray1
        $0.isScrollEnabled = false
        $0.makeRound()
        $0.textContainerInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 44)
    }
    
    private lazy var sendButton = UIButton().then {
        $0.setImage(Constant.Image.ic, for: .normal)
    }
    
    // MARK: - Property
    
    let viewModel = ChatViewModel()
    private let disposeBag = DisposeBag()

    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        configureNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureAttribute()
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 소켓 통신 disconnection
    }
}

extension ChatViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        view.addSubviews(navigationBar, tableView, messageTextView)
        messageTextView.addSubview(sendButton)
        
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
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(68)
        }
        
        messageTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(Metric.margin)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).inset(-Metric.margin)
            make.height.equalTo(52)
        }
        
        sendButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(307)
            make.trailing.equalToSuperview().inset(12)
            make.width.height.equalTo(24)
        }
    }
    
    func configureAttribute() {
        view.backgroundColor = .white
    }
    
    private func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func configureDataSource() -> RxTableViewSectionedReloadDataSource<ChatSection> {
        let dataSource = RxTableViewSectionedReloadDataSource<ChatSection> { dataSource, tableView, indexPath, item in
            if indexPath.section == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.reuseIdentifier, for: indexPath) as? HeaderTableViewCell else { return UITableViewCell() }
                cell.setData(date: item.createdAt, nick: item.chat)
                return cell
            } else {
                if item.id == "sokyte" {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: MyBubbleTableViewCell.reuseIdentifier, for: indexPath) as? MyBubbleTableViewCell else { return UITableViewCell() }
                    cell.setData(item.chat, item.createdAt)
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: OtherBubbleTableViewCell.reuseIdentifier, for: indexPath) as? OtherBubbleTableViewCell else { return UITableViewCell() }
                    cell.setData(item.chat, item.createdAt)
                    return cell
                }
            }
        }
        
        return dataSource
    }
    
    func bind() {
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
        
        let dataSource = configureDataSource()
        viewModel.chatRelay
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        messageTextView.rx.didBeginEditing
            .withUnretained(self)
            .bind { vc, _ in
                vc.messageTextView.text = (vc.messageTextView.text == "메세지를 입력하세요") ? "" : "메세지를 입력하세요"
            }
            .disposed(by: disposeBag)
        
        messageTextView.rx.didChange
            .withUnretained(self)
            .bind { vc, _ in
                vc.messageTextView.textColor = .black
                
                let size = CGSize(width: vc.messageTextView.frame.width, height: .infinity)
                let estimatedSize = vc.messageTextView.sizeThatFits(size)
                
                if estimatedSize.height > 100 {
                    vc.messageTextView.isScrollEnabled = true
                    
                    vc.messageTextView.constraints.forEach { (constraint) in
                        if constraint.firstAttribute == .height {
                            constraint.constant = 100
                        }
                    }
                } else {
                    vc.messageTextView.isScrollEnabled = false
                    
                    vc.messageTextView.constraints.forEach { (constraint) in
                        if constraint.firstAttribute == .height {
                            constraint.constant = estimatedSize.height
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableView Protocol

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
}
