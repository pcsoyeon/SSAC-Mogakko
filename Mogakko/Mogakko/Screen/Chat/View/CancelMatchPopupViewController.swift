//
//  CancelMatchPopupViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/26.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

@frozen
enum CancelMatchType {
    case matching
    case plain
}

final class CancelMatchPopupViewController: UIViewController {

    // MARK: - UI Property
    
    private var popupView = MDSPopupView()
    
    // MARK: - Property
    
    var cancelMatchType: CancelMatchType = .matching {
        didSet {
            configurePopupView(cancelMatchType)
        }
    }
    
    var uid: String = ""
    
    var isCanceled: ((Bool) -> Void)?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureAttribute()
        bind()
    }
}

extension CancelMatchPopupViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        view.addSubview(popupView)
        
        popupView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview()
        }
    }
    
    func configureAttribute() {
        view.backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    private func configurePopupView(_ type: CancelMatchType) {
        switch type {
        case .matching:
            popupView.title = "스터디를 취소하시겠습니까"
            popupView.subtitle = "스터디를 취소하시면 패털티가 부과됩니다"
        case .plain:
            popupView.title = "스터디를 종료하시겠습니까"
            popupView.subtitle = """
                                 상대방이 스터디를 취소했기 때문에
                                 패널티가 부과되지 않습니다
                                 """
            popupView.numberOfLines = 2
        }
    }
    
    func bind() {
        popupView.addActionToButton { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        } comfirmCompletion: { [weak self] in
            guard let self = self else { return }
            self.requestDodge()
        }
    }
}

// MARK: - Network

extension CancelMatchPopupViewController {
    private func requestDodge() {
        QueueAPI.shared.requestDodge(uid: uid) { [weak self] statusCode in
            guard let self = self else { return }
            print("============== 스터디 취소 \(statusCode)")
            
            if statusCode == 200 {
                self.isCanceled?(true)
                self.dismiss(animated: true)
            } else if statusCode == 201 {
                self.showToast(message: "스터디 취소 실패")
                print("현재 매칭된 새싹의 otheruid 값으로 ‘스터디 취소’를 요청했는지 확인")
            } else {
                
            }
        }
    }
}
