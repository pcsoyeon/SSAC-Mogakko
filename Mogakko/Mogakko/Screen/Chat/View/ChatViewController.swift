//
//  ChatViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/21.
//

import UIKit

import RealmSwift
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
        $0.estimatedSectionHeaderHeight = 0.0
        
        $0.separatorStyle = .none
        
        $0.register(HeaderTableViewCell.self, forCellReuseIdentifier: HeaderTableViewCell.reuseIdentifier)
        $0.register(MyBubbleTableViewCell.self, forCellReuseIdentifier: MyBubbleTableViewCell.reuseIdentifier)
        $0.register(OtherBubbleTableViewCell.self, forCellReuseIdentifier: OtherBubbleTableViewCell.reuseIdentifier)
    }
    
    private var isOpen: Bool = false
    
    private var menuBackView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.5)
//        $0.alpha = 0
//        $0.isHidden = true
    }
    
    private lazy var menuStackView = UIStackView().then {
        $0.backgroundColor = .white
        $0.axis = .horizontal
        $0.spacing = 0
        $0.distribution = .fillEqually
        $0.addArrangedSubviews(sirenButton, cancelButton, writeButton)
//        $0.alpha = 0
//        $0.isHidden = true
    }
    
    private var sirenButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = Constant.Image.siren
        config.imagePadding = 4
        config.imagePlacement = NSDirectionalRectEdge.top
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 0)
        config.baseForegroundColor = .black
        var titleAttr = AttributedString.init("새싹 신고")
        titleAttr.font = MDSFont.Title3_M14.font
        config.attributedTitle = titleAttr
        $0.configuration = config
        $0.isHidden = true
    }
    
    private var cancelButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = Constant.Image.cancelMatch
        config.imagePadding = 4
        config.imagePlacement = NSDirectionalRectEdge.top
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 0)
        config.baseForegroundColor = .black
        var titleAttr = AttributedString.init("스터디 취소")
        titleAttr.font = MDSFont.Title3_M14.font
        config.attributedTitle = titleAttr
        $0.configuration = config
        $0.isHidden = true
    }
    
    private var writeButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = Constant.Image.wirte
        config.imagePadding = 4
        config.imagePlacement = NSDirectionalRectEdge.top
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.baseForegroundColor = .black
        var titleAttr = AttributedString.init("리뷰 등록")
        titleAttr.font = MDSFont.Title3_M14.font
        config.attributedTitle = titleAttr
        $0.configuration = config
        $0.isHidden = true
    }
    
    private lazy var messageTextView = UITextView().then {
        $0.text = placeholder
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
    
    private let placeholder = "메세지를 입력하세요"
    private var keyboardHeight = 0.0
    
    private var cancelMatchType: CancelMatchType = .matching

    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        configureNavigationBar()
        
        requestMyState()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureAttribute()
        bind()
        
        getNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SocketIOManager.shared.closeConnection()
    }
    
    private func getNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage(notification:)), name: NSNotification.Name("getMessage"), object: nil)
    }
    
    @objc func getMessage(notification: NSNotification) {
        let id = notification.userInfo!["_id"] as! String
        let chat = notification.userInfo!["chat"] as! String
        let createdAt = notification.userInfo!["createdAt"] as! String
        let from = notification.userInfo!["from"] as! String
        let to = notification.userInfo!["to"] as! String
        
        let value = Chat(id: id, to: to, from: from, chat: chat, createdAt: createdAt)
        viewModel.appendChatToSection(value)
        if !viewModel.chatList.isEmpty {
            tableView.scrollToRow(at: IndexPath(row: viewModel.chatList.count - 1, section: 1), at: .bottom, animated: true)
        }
    }
}

extension ChatViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        view.addSubviews(navigationBar, tableView, messageTextView)
        
        view.addSubview(menuBackView)
        menuBackView.addSubview(menuStackView)
        
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
        
        menuBackView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
//            make.height.equalTo(724)
            make.height.equalTo(0)
        }
        
        menuStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
//            make.height.equalTo(72)
            make.height.equalTo(0)
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
        let dataSource = RxTableViewSectionedReloadDataSource<ChatSection> { [weak self] dataSource, tableView, indexPath, item in
            guard let self = self else { return UITableViewCell() }
            
            if indexPath.section == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.reuseIdentifier, for: indexPath) as? HeaderTableViewCell else { return UITableViewCell() }
                cell.setData(date: item.createdAt, nick: item.chat)
                return cell
            } else {
                if item.from == self.viewModel.uid {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: OtherBubbleTableViewCell.reuseIdentifier, for: indexPath) as? OtherBubbleTableViewCell else { return UITableViewCell() }
                    cell.setData(item.chat, item.createdAt)
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: MyBubbleTableViewCell.reuseIdentifier, for: indexPath) as? MyBubbleTableViewCell else { return UITableViewCell() }
                    cell.setData(item.chat, item.createdAt)
                    return cell
                }
            }
        }
        
        return dataSource
    }
    
    func bind() {
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
        
        tableView.keyboardDismissMode = .onDrag
        
        tableView.rx.itemSelected
            .withUnretained(self)
            .bind { vc, _ in
                vc.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
//        NotificationCenter.default.rx.notification(UIResponder.keyboardDidShowNotification)
//            .withUnretained(self)
//            .bind { vc, notification in
//                if let userInfo = notification.userInfo,
//                   let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
//                    vc.keyboardHeight = keyboardRectangle.height
//                }
//            }
//            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardDidHideNotification)
            .withUnretained(self)
            .bind { vc, notification in
                vc.tableView.contentInset = .zero
                
                if !vc.viewModel.chatList.isEmpty {
                    vc.tableView.scrollToRow(at: IndexPath(row: vc.viewModel.chatList.count - 1, section: 1), at: .bottom, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        messageTextView.rx.didBeginEditing
            .withUnretained(self)
            .bind { vc, _ in
                // TODO: - Bottom Inset 수정
                vc.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 291, right: 0)
                if !vc.viewModel.chatList.isEmpty {
                    vc.tableView.scrollToRow(at: IndexPath(row: vc.viewModel.chatList.count - 1, section: 1), at: .bottom, animated: true)
                }
                
                if vc.messageTextView.text == vc.placeholder {
                    vc.messageTextView.text = ""
                }
            }
            .disposed(by: disposeBag)
        
        messageTextView.rx.didEndEditing
            .withUnretained(self)
            .bind { vc, _ in
                vc.tableView.contentInset = .zero
                if !vc.viewModel.chatList.isEmpty {
                    vc.tableView.scrollToRow(at: IndexPath(row: vc.viewModel.chatList.count - 1, section: 1), at: .bottom, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        messageTextView.rx.didChange
            .withUnretained(self)
            .bind { vc, _ in
                if vc.messageTextView.text != vc.placeholder {
                    vc.sendButton.setImage(Constant.Image.icAct, for: .normal)
                    vc.sendButton.tintColor = .green
                } else {
                    vc.sendButton.setImage(Constant.Image.ic, for: .normal)
                    vc.messageTextView.textColor = .black
                }
                
                vc.messageTextView.textColor = .black
                
                let size = CGSize(width: vc.messageTextView.frame.width, height: .infinity)
                let estimatedSize = vc.messageTextView.sizeThatFits(size)
                
                if estimatedSize.height > 72 {
                    vc.messageTextView.isScrollEnabled = true
                    
                    vc.messageTextView.constraints.forEach { (constraint) in
                        if constraint.firstAttribute == .height {
                            constraint.constant = 72
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
        
        sendButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                if vc.messageTextView.text != vc.placeholder {
                    if let text = vc.messageTextView.text {
                        vc.postChat(text: text)
                        vc.messageTextView.text = ""
                        vc.messageTextView.endEditing(true)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        moreButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.isOpen.toggle()
                
                if vc.isOpen {
//                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
//                        vc.menuBackView.alpha = 1
//                        vc.menuStackView.alpha = 1
//                    }
//                    vc.menuBackView.isHidden = false
                    
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                        self.menuBackView.snp.updateConstraints { make in
                            make.height.equalTo(UIScreen.main.bounds.height - 44 - 72)
                        }

                        self.menuStackView.snp.updateConstraints { make in
                            make.height.equalTo(72)
                        }

                        [vc.sirenButton, vc.cancelButton, vc.writeButton].forEach {
                            $0.isHidden = false
                        }
                    }
                } else {
//                    vc.hideMenuView()
                    
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                        self.menuBackView.snp.updateConstraints { make in
                            make.height.equalTo(0)
                        }
                        
                        self.menuStackView.snp.updateConstraints { make in
                            make.height.equalTo(0)
                        }
                        
                        [vc.sirenButton, vc.cancelButton, vc.writeButton].forEach {
                            $0.isHidden = true
                        }
                    }
                    
                }
            }
            .disposed(by: disposeBag)
        
        writeButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.hideMenuView()
                
                let popupViewController = WriteReviewPopupViewController()
                popupViewController.modalTransitionStyle = .crossDissolve
                popupViewController.modalPresentationStyle = .overFullScreen
                popupViewController.uid = vc.viewModel.uid
                popupViewController.registerComment = { registerComment in
                    if registerComment {
                        vc.navigationController?.popToRootViewController(animated: false)
                    }
                }
                vc.present(popupViewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.hideMenuView()
                
                let popupViewController = CancelMatchPopupViewController()
                popupViewController.modalTransitionStyle = .crossDissolve
                popupViewController.modalPresentationStyle = .overFullScreen
                popupViewController.uid = vc.viewModel.uid
                popupViewController.cancelMatchType = vc.cancelMatchType
                popupViewController.isCanceled = { isCanceled in
                    if isCanceled {
                        vc.navigationController?.popToRootViewController(animated: false)
                    }
                }
                vc.present(popupViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func hideMenuView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.menuBackView.alpha = 0
            self.menuStackView.alpha = 0
        }
        menuBackView.isHidden = true
    }
}

// MARK: - UITableView Protocol

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
}

// MARK: - Network

extension ChatViewController {
    func fetchChatList() {
        viewModel.fetchChatListByDB { [weak self] statusCode in
            guard let self = self else { return }
            
            if statusCode == 200 {
                SocketIOManager.shared.establishConnection()
                if !self.viewModel.chatList.isEmpty {
                    self.tableView.scrollToRow(at: IndexPath(row: self.viewModel.chatList.count - 1, section: 1), at: .bottom, animated: true)
                }
            } else {
                guard let error = APIError(rawValue: statusCode) else { return }
                switch error {
                case .takenUser, .invalidNickname:
                    return
                case .invalidAuthorization, .serverError, .emptyParameters:
                    self.showToast(message: "\(String(describing: error.errorDescription))")
                case .unsubscribedUser:
                    Helper.convertNavigationRootViewController(view: self.view, controller: NicknameViewController())
                }
            }
        }
    }
    
    func postChat(text: String) {
        viewModel.postChat(text: text) { [weak self] statusCode in
            guard let self = self else { return }
            
            if statusCode == 200 {
                if !self.viewModel.chatList.isEmpty {
                    self.tableView.scrollToRow(at: IndexPath(row: self.viewModel.chatList.count - 1, section: 1), at: .bottom, animated: true)
                }
            } else if statusCode == 201 {
                self.showToast(message: "스터디가 종료되어 채팅을 전송할 수 없습니다")
                self.cancelMatchType = .plain
                
                var config = UIButton.Configuration.plain()
                var titleAttr = AttributedString.init("스터디 종료")
                titleAttr.font = MDSFont.Title3_M14.font
                config.attributedTitle = titleAttr
                self.cancelButton.configuration = config
            } else if statusCode == 401 {
                UserAPI.shared.refreshIdToken { result in
                    switch result {
                    case .success(let idToken):
                        UserData.idtoken = idToken
                        self.postChat(text: text)
                    case .failure(let error):
                        self.showToast(message: error.localizedDescription)
                    }
                }
            } else if statusCode == 406 {
                self.showToast(message: "미가입 회원입니다.")
                Helper.convertNavigationRootViewController(view: self.view, controller: NicknameViewController())
            } else if statusCode == 500 {
                self.showToast(message: "서버 오류입니다.")
            }
        }
    }
    
    func requestMyState() {
        viewModel.requestMyState { [weak self] response, error in
            guard let self = self else { return }
            
            if let response = response {
                self.navigationBar.title = response.matchedNick ?? ""
                
                if response.matched == 1 {
                    self.fetchChatList()
                    
                    if response.dodged == 1 {
                        // 매칭 + 취소된 상태
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            self.showToast(message: "스터디가 종료되어 채팅을 전송할 수 없습니다")
                        }
                        self.cancelMatchType = .plain
                        
                        var config = UIButton.Configuration.plain()
                        var titleAttr = AttributedString.init("스터디 종료")
                        titleAttr.font = MDSFont.Title3_M14.font
                        config.attributedTitle = titleAttr
                        self.cancelButton.configuration = config
                    }
                }
            }
            
            if let error = error {
                self.showToast(message: error.localizedDescription)
            }
        }
    }
}
