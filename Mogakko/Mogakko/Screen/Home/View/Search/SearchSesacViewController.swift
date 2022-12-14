//
//  SearchSesacViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/19.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class SearchSesacViewController: UIViewController {
    
    // MARK: - UI Property
    
    private lazy var navigationBar = MDSNavigationBar(self).then {
        $0.backButtonIsHidden = false
        $0.title = "새싹 찾기"
        $0.addSubviews(backButton, stopButton)
    }
    
    private var backButton = UIButton().then {
        $0.setImage(Constant.Image.arrow, for: .normal)
        $0.isHidden = true
    }
    
    private var stopButton = UIButton().then {
        $0.setTitle("찾기중단", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = MDSFont.Title3_M14.font
    }
    
    private var scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
    }
    
    private var contentStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
        $0.spacing = 0
    }
    
    private lazy var indicatorView = UIView().then {
        $0.addSubviews(fromTitleButton, requestedTitleButton, underLineView, indicatorLine)
    }
    
    private var fromTitleButton = UIButton().then {
        $0.setTitle("주변 새싹", for: .normal)
        $0.setTitleColor(.green, for: .normal)
        $0.titleLabel?.font = MDSFont.Title3_M14.font
    }
    
    private var requestedTitleButton = UIButton().then {
        $0.setTitle("받은 요청", for: .normal)
        $0.setTitleColor(.gray6, for: .normal)
        $0.titleLabel?.font = MDSFont.Title4_R14.font
    }
    
    private var indicatorLine = UIView().then {
        $0.backgroundColor = .green
    }
    
    private var underLineView = UIView().then {
        $0.backgroundColor = .gray2
    }
    
    private let fromQueueView = NearbyView()
    private let requestedView = AcceptView()
    
    // MARK: - Property
    
    private let viewModel = SearchSesacViewModel()
    private let disposeBag = DisposeBag()
    
    var mapLatitude = 0.0
    var mapLongitude = 0.0
    
    var stateType: MDSFloatingButtonType = .plain {
        didSet {
            navigationBar.backButtonIsHidden = (stateType == .matching) ? true : false
            backButton.isHidden = (stateType == .matching) ? false : true
        }
    }
    
    var timer : Timer?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAttribute()
        configureHierarchy()
        bind()
        
        //5초마다
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(requestMyQueueState), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
    }
}

extension SearchSesacViewController: BaseViewControllerAttribute {
    func configureAttribute() {
        view.backgroundColor = .white
    }
    
    func configureHierarchy() {
        view.addSubviews(navigationBar, indicatorView, scrollView)
        scrollView.addSubview(contentStackView)
        contentStackView.addArrangedSubviews(fromQueueView, requestedView)
        
        // 네비게이션
        navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(Metric.margin)
        }
        
        stopButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(Metric.margin)
        }
        
        // 인디케이터
        indicatorView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(43)
        }
        
        fromTitleButton.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.equalTo(view.frame.width / 2)
        }
        
        requestedTitleButton.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.width.equalTo(view.frame.width / 2)
        }
        
        indicatorLine.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.leading.bottom.equalToSuperview()
            make.width.equalTo(view.frame.width / 2)
        }
        
        underLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        // 스크롤 뷰
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(indicatorView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        let views = [fromQueueView, requestedView]
        
        contentStackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(views.count)
        }
        
        for view in views {
            view.snp.makeConstraints {
                $0.width.equalTo(scrollView.snp.width)
                $0.height.equalToSuperview()
            }
        }
    }
    
    func bind() {
        viewModel.requestSearch(request: SearchRequest(lat: mapLatitude, long: mapLongitude)) { error in
            if let error = error {
                print("error - \(error.errorDescription ?? "")")
            }
        }
        
        viewModel.fromQueue
            .withUnretained(self)
            .bind { vc, list in
                print("============ 💗 주변 새싹 💗 ============")
                dump(list)
                vc.fromQueueView.list = list
//                vc.fromQueueView.fromQueueRelay.accept(list)
            }
            .disposed(by: disposeBag)
        
        fromQueueView.tapMatchButton
            .skip(1)
            .withUnretained(self)
            .bind { vc, queue in
                let viewController = NearbyPopupViewController()
                viewController.queue = queue
                viewController.modalTransitionStyle = .crossDissolve
                viewController.modalPresentationStyle = .overFullScreen
                vc.present(viewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        requestedView.tapMatchButton
            .skip(1)
            .withUnretained(self)
            .bind { vc, queue in
                let viewController = AcceptPopupViewController()
                viewController.queue = queue
                viewController.modalTransitionStyle = .crossDissolve
                viewController.modalPresentationStyle = .overFullScreen
                vc.present(viewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.fromRequestedQueue
            .withUnretained(self)
            .bind { vc, list in
                print("============ 💗 스터디를 요청한 새싹 💗 ============")
                dump(list)
                vc.requestedView.list = list
            }
            .disposed(by: disposeBag)
        
        scrollView.rx.didScroll
            .withUnretained(self)
            .map { vc, _ in
                return Int(vc.scrollView.contentOffset.x / vc.scrollView.frame.size.width)
            }
            .bind { [weak self] index in
                guard let self = self else { return }
                if index == 0 {
                    self.highlightedTitle(index: 0, selectedButton: self.fromTitleButton, deselectedButton: self.requestedTitleButton)
                } else {
                    self.highlightedTitle(index: 1, selectedButton: self.requestedTitleButton, deselectedButton: self.fromTitleButton)
                }
            }
            .disposed(by: disposeBag)
        
        fromTitleButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
            .disposed(by: disposeBag)
        
        requestedTitleButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.scrollView.setContentOffset(CGPoint(x: vc.scrollView.frame.width, y: 0), animated: true)
            }
            .disposed(by: disposeBag)
        
        [fromQueueView.emptyView.changeButton].forEach {
            $0.rx.tap
                .withUnretained(self)
                .bind { vc, _ in
                    vc.viewModel.deleteQueue { statusCode in
                        if statusCode == 200 {
                            vc.navigationController?.popViewController(animated: true)
                        } else if statusCode == 201 {
                            vc.showToast(message: "누군가와 스터디를 함께하기로 약속하셨어요!")
                            let viewController = ChatViewController()
                            vc.navigationController?.pushViewController(viewController, animated: true)
                        } else {
                            vc.handleOtherStausCode(statusCode)
                        }
                    }
                    
                }
                .disposed(by: disposeBag)
        }
        
        requestedView.emptyView.changeButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        [fromQueueView.emptyView.refreshButton, requestedView.emptyView.refreshButton].forEach {
            $0.rx.tap
                .withUnretained(self)
                .bind { vc, _ in
                    vc.viewModel.requestSearch(request: SearchRequest(lat: vc.mapLatitude, long: vc.mapLongitude)) { error in
                        if let error = error {
                            vc.showToast(message: error.errorDescription ?? "")
                        }
                    }
                }
                .disposed(by: disposeBag)
        }
        
        backButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
            }
            .disposed(by: disposeBag)
        
        stopButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.viewModel.deleteQueue { statusCode in
                    if statusCode == 200 {
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                    } else if statusCode == 201 {
                        vc.showToast(message: "누군가와 스터디를 함께하기로 약속하셨어요!")
                        let viewController = ChatViewController()
                        vc.navigationController?.pushViewController(viewController, animated: true)
                    } else {
                        vc.handleOtherStausCode(statusCode)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func highlightedTitle(index: Int, selectedButton: UIButton, deselectedButton: UIButton) {
        if index == 0 {
            UIView.animate(withDuration: 0.35) {
                self.indicatorLine.snp.updateConstraints { make in
                    make.leading.equalToSuperview()
                }
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.indicatorLine.snp.updateConstraints { make in
                    make.leading.equalToSuperview().inset(self.view.frame.width / 2)
                }
                self.view.layoutIfNeeded()
            }
        }
        
        selectedButton.setTitleColor(.green, for: .normal)
        selectedButton.titleLabel?.font = MDSFont.Title3_M14.font
        
        deselectedButton.setTitleColor(.gray6, for: .normal)
        deselectedButton.titleLabel?.font = MDSFont.Title4_R14.font
    }
    
    @objc func requestMyQueueState() {
        QueueAPI.shared.requestMyQueue { [weak self] response, statusCode in
            guard let self = self else { return }
            
            if let statusCode = statusCode {
                switch statusCode {
                case 201:
                    self.showToast(message: "새싹 찾기를 요청하지 않은 상태입니다.")
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                    self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                    return
                default:
                    self.handleOtherStausCode(statusCode)
                    return
                }
            }
            
            if let response = response {
                if response.matched == 0 {
                    return
                } else {
                    self.showToast(message: "\(response.matchedNick ?? "")님과 매칭되셨습니다. 잠시 후 채팅방으로 이동합니다")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        let viewController = ChatViewController()
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
            }
        }
    }
    
    private func refreshToken(_ idtoken: String) {
        GenericAPI.shared.requestDecodableData(type: Login.self, router: UserRouter.refresh(idToken: idtoken)) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                UserData.nickName = data.nick
                self.requestMyQueueState()
            case .failure(_):
                self.showToast(message: "토큰 만료")
            }
        }
    }
    
    private func handleOtherStausCode(_ statusCode: Int) {
        switch statusCode {
        case 401:
            UserAPI.shared.refreshIdToken { result in
                switch result {
                case .success(let idtoken):
                    print("갱신 - ", UserData.idtoken)
                    self.refreshToken(idtoken)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    return
                }
            }
            return
        case 406:
            self.showToast(message: "미가입 회원입니다.")
            Helper.convertNavigationRootViewController(view: self.view, controller: NicknameViewController())
            return
        case 500:
            self.showToast(message: "서버 내부 오류입니다. 잠시 후 다시 시도해주세요")
            return
        case 501:
            self.showToast(message: "요청 값을 확인해주세요.")
            return
        default:
            return
        }
    }

}
