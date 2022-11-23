//
//  AcceptPopupViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/23.
//

import UIKit

class AcceptPopupViewController: UIViewController {

    // MARK: - Property
    
    var uid: String = ""
    
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
        QueueAPI.shared.requestAccept(uid: uid) { [weak self] statusCode in
            guard let self = self else { return }
            
            if statusCode == 200 {
                self.dismiss(animated: true)
            } else if statusCode == 201 {
                self.showToast(message: "상대방이 이미 다른 새싹과 스터디를 함께 하는 중입니다")
            } else if statusCode == 202 {
                self.showToast(message: "상대방이 스터디 찾기를 그만두었습니다")
            } else if statusCode == 203 {
                self.showToast(message: "앗! 누군가가 나의 스터디를 수락하였어요!")
                // TODO: - Toast 메시지 후 (get, /v1/queue/myQueueState) 호출
            } else {
                // extra error handling
            }
        }
    }
}
