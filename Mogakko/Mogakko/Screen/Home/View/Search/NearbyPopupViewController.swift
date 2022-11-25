//
//  RequestStudyViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/23.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class NearbyPopupViewController: UIViewController {
    
    // MARK: - Property
    
    var queue: FromQueue = FromQueue(uid: "", nick: "", lat: 0.0, long: 0.0, reputation: [], studylist: [], reviews: [], gender: 0, type: 0, sesac: 0, background: 0)
    
    // MARK: - UI Property
    
    private var popupView = MDSPopupView().then {
        $0.title = "스터디를 요청할게요!"
        $0.subtitle = """
                      상대방이 요청을 수락하면
                      채팅창에서 대화를 나눌 수 있어요
                      """
        $0.numberOfLines = 2
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureAttribute()
        bind()
    }
}

extension NearbyPopupViewController: BaseViewControllerAttribute {
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
            self.requestStudy()
        }
    }
}

// MARK: - Network

extension NearbyPopupViewController {
    private func requestStudy() {
        QueueAPI.shared.requestStudy(uid: queue.uid) { [weak self] statusCode in
            guard let self = self else { return }
            
            guard let presentingViewController = self.presentingViewController else { return }
            
            if statusCode == 200 {
                self.dismiss(animated: true) {
                    presentingViewController.showToast(message: "스터디 요청을 보냈습니다")
                }
            } else if statusCode == 201 {
                // 상대방이 이미 나에게 스터디 요청한 상태
                // {baseURL}/v1/queue/studyaccept 호출
                // (post, /v1/queue/studyaccept) 를 호출하고 (post, /v1/queue/studyaccept) 에 대해 응답 코드 200을 받았다면, 사용자 현재 상태를 매칭 상태로 변경하고 팝업 화면을 dismiss합니다.
                // 팝업 화면이 사라진 이후에 새싹 찾기 화면 하단에 “상대방도 스터디를 요청하여 매칭되었습니다. 잠시 후 채팅방으로 이동합니다” 토스트 메시지를 띄운 뒤, 채팅 화면(1_5_chatting)으로 화면을 전환합니다.
                self.requestAccept()
                self.dismiss(animated: true)
            } else if statusCode == 202 {
                // 상대방이 취소한 경우
                self.showToast(message: "상대방이 스터디 찾기를 그만두었습니다")
                self.dismiss(animated: true)
            }
        }
    }
    
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
                self.requestMyState()
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
