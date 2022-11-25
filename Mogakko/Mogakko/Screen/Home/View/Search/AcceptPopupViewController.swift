//
//  AcceptPopupViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/23.
//

import UIKit

class AcceptPopupViewController: UIViewController {

    // MARK: - Property
    
    var queue: FromQueue = FromQueue(uid: "", nick: "", lat: 0.0, long: 0.0, reputation: [], studylist: [], reviews: [], gender: 0, type: 0, sesac: 0, background: 0)
    
    // MARK: - UI Property
    
    private var popupView = MDSPopupView().then {
        $0.title = "스터디를 수락할까요?"
        $0.subtitle = "요청을 수락하면 채팅창에서 대화를 나눌 수 있어요"
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureAttribute()
        bind()
    }
}

extension AcceptPopupViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        view.addSubview(popupView)
        
        popupView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview()
        }
    }
    
    func configureAttribute() {
        view.backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    func bind() {
        popupView.addActionToButton { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        } comfirmCompletion: { [weak self] in
            guard let self = self else { return }
            self.requestAccept()
        }
    }
}

// MARK: - Network

extension AcceptPopupViewController {
    private func requestAccept() {
        QueueAPI.shared.requestAccept(uid: queue.uid) { [weak self] statusCode in
            guard let self = self else { return }
            
            if statusCode == 200 {
                guard let presentingViewController = self.presentingViewController else { return }
                let navigationController = presentingViewController is UINavigationController ? presentingViewController as? UINavigationController : presentingViewController.navigationController
                self.dismiss(animated: true) {
                    let viewController = ChatViewController()
                    viewController.viewModel.uid.accept(self.queue.uid)
                    viewController.viewModel.nick.accept(self.queue.nick)
                    navigationController?.pushViewController(viewController, animated: true)
                }
            } else if statusCode == 201 {
                self.showToast(message: "상대방이 이미 다른 새싹과 스터디를 함께 하는 중입니다")
                self.dismiss(animated: true)
            } else if statusCode == 202 {
                self.showToast(message: "상대방이 스터디 찾기를 그만두었습니다")
                self.dismiss(animated: true)
            } else if statusCode == 203 {
                self.showToast(message: "앗! 누군가가 나의 스터디를 수락하였어요!")
                self.dismiss(animated: true)
            } else {
                // extra error handling
            }
        }
    }
    
    private func requestMyState() {
        GenericAPI.shared.requestDecodableData(type: MyStateResponse.self, router: QueueRouter.myQueueState) { [weak self] response in
            guard let self = self else { return }
            
            switch response {
            case .success(let data):
                if data.matched == 0 {
                    // 매칭 되지 않은 경우
                } else {
                    // 매칭 된 경우
                    // 채팅화면으로 이동 ???
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
