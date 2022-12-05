//
//  WriteReviewPopupViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/26.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class WriteReviewPopupViewController: UIViewController {
    
    // MARK: - UI Property
    
    private let popupView = UIView().then {
        $0.backgroundColor = .white
        $0.makeRound(radius: 20)
    }
    
    private let closeButton = UIButton().then {
        $0.setImage(Constant.Image.closeBig.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = .gray5
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "리뷰 등록"
        $0.textColor = .black
        $0.font = MDSFont.Title3_M14.font
    }
    
    private let subtitleLabel = UILabel().then {
        $0.textColor = .green
        $0.font = MDSFont.Title4_R14.font
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout).then {
        $0.isScrollEnabled = false
        $0.allowsMultipleSelection = true
        $0.isUserInteractionEnabled = true
    }
    
    private var collectionLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
    }
    
    private lazy var commentTextView = UITextView().then {
        $0.backgroundColor = .gray1
        $0.textColor = .gray7
        $0.makeRound()
        $0.font = MDSFont.Body3_R14.font
        $0.text = placeholder
        $0.textContainerInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 44)
    }
    
    private let registerButton = MDSButton().then {
        $0.type = .disable
        $0.heightType = .h48
        $0.text = "리뷰 등록하기"
    }
    
    // MARK: - Property
    
    private let disposeBag = DisposeBag()
    
    var uid: String = ""
    
    var nick: String = "" {
        didSet {
            subtitleLabel.text = "\(nick)님과의 스터디는 어떠셨나요?"
        }
    }
    
    private var reputationTitle: [String] = ["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 실력", "유익한 시간"]
    private var reputation: [Int] = Array(repeating: 0, count: 9)
    
    private let placeholder = "자세한 피드백은 다른 새싹들에게 도움이 됩니다 (500자 이내 작성)"
    
    var registerComment: ((Bool) -> Void)?

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureAttribute()
        bind()
    }
}

extension WriteReviewPopupViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        view.addSubview(popupView)
        popupView.addSubviews(closeButton, titleLabel, subtitleLabel, collectionView, commentTextView, registerButton)
        
        popupView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metric.margin)
            make.height.equalTo(410)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).inset(-181)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(Metric.margin)
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(17)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(17)
            make.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(Metric.margin)
            make.height.equalTo(112)
        }
        
        commentTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metric.margin)
            make.top.equalTo(collectionView.snp.bottom).offset(24)
            make.bottom.equalTo(registerButton.snp.top).inset(-24)
        }
        
        registerButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview().inset(Metric.margin)
        }
    }
    
    func configureAttribute() {
        view.backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    func bind() {
        closeButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.reuseIdentifier)
        
        let listObservable = Observable.of(reputationTitle)
        listObservable.bind(to: collectionView.rx.items(cellIdentifier: TitleCollectionViewCell.reuseIdentifier, cellType: TitleCollectionViewCell.self)) { index, data, cell in
            cell.setData(data)
            cell.isActive = false
        }
        .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        registerButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                print(vc.reputation)
                if vc.commentTextView.text == vc.placeholder {
                    vc.requestRate(uid: vc.uid, reputation: vc.reputation, comment: "")
                } else {
                    if vc.commentTextView.hasText {
                        vc.requestRate(uid: vc.uid, reputation: vc.reputation, comment: vc.commentTextView.text)
                    } else {
                        vc.requestRate(uid: vc.uid, reputation: vc.reputation, comment: "")
                    }
                }
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .withUnretained(self)
            .bind { vc, _ in
                vc.popupView.snp.updateConstraints { make in
                    make.bottom.equalTo(vc.view.keyboardLayoutGuide.snp.top).inset(-16)
                }
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .withUnretained(self)
            .bind { vc, _ in
                vc.popupView.snp.updateConstraints { make in
                    make.bottom.equalTo(vc.view.keyboardLayoutGuide.snp.top).inset(-181)
                }
            }
            .disposed(by: disposeBag)
        
        commentTextView.rx.didBeginEditing
            .withUnretained(self)
            .bind { vc, _ in
                if vc.commentTextView.text == vc.placeholder {
                    vc.commentTextView.text = ""
                }
            }
            .disposed(by: disposeBag)
        
        commentTextView.rx.didChange
            .withUnretained(self)
            .bind { vc, _ in
                if vc.commentTextView.hasText {
                    vc.commentTextView.textColor = .black
                    vc.registerButton.type = .fill
                } else {
                    vc.registerButton.type = .disable
                }
            }
            .disposed(by: disposeBag)
        
        commentTextView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension WriteReviewPopupViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 8) / 2
        let height = (collectionView.frame.height - 8 - 8) / 3
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.reuseIdentifier, for: indexPath) as? TitleCollectionViewCell else { return }
        cell.isActive = true
        if reputation[indexPath.item] == 0 {
            reputation[indexPath.item] = 1
        } else {
            reputation[indexPath.item] = 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.reuseIdentifier, for: indexPath) as? TitleCollectionViewCell else { return }
        cell.isActive = false
        if reputation[indexPath.item] == 0 {
            reputation[indexPath.item] = 1
        } else {
            reputation[indexPath.item] = 0
        }
    }
}

// MARK: - UITextView Protocol

extension WriteReviewPopupViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let str = textView.text else { return true }
        let newLength = str.count + text.count - range.length
        return newLength <= 500
    }
}

// MARK: - Network

extension WriteReviewPopupViewController {
    private func requestRate(uid: String, reputation: [Int], comment: String) {
        
        QueueAPI.shared.requestRate(uid: uid, reputation: reputation, comment: comment) { [weak self] statusCode in
            guard let self = self else { return }
            print(statusCode)
            if statusCode == 200 {
                self.registerComment?(true)
                self.dismiss(animated: true)
            } else {
                
            }
        }
    }
}
