//
//  CardTableViewCell.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/19.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class CardTableViewCell: BaseTableViewCell {
    
    // MARK: - Property
    
    var isExpanded: Bool = false {
        didSet {
            cardView.isExpanded = isExpanded
        }
    }
    
    var matchButtonType: MDSMatchType = .propose {
        didSet {
            matchButton.type = matchButtonType
            matchButton.isHidden = matchButtonType == .hidden ? true : false
        }
    }
    
    var tapMatchButton : PublishSubject<Bool> = PublishSubject()
    var disposeBag = DisposeBag()
    
    // MARK: - UI Property
    
    var cardView = CardView().then {
        $0.isExpanded = false
        $0.cardViewType = .plain
    }
    
    var matchButton = MDSMatchButton().then {
        $0.type = .hidden
    }
    
    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func configureAttribute() {
        backgroundColor = .white
        
        matchButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.tapMatchButton.onNext(true)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        contentView.addSubviews(cardView, matchButton)
        cardView.snp.makeConstraints { make in
            make.verticalEdges.horizontalEdges.equalToSuperview()
        }
        
        matchButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12 + 16)
                make.trailing.equalToSuperview().inset(12 + 14)
        }
    }
}
