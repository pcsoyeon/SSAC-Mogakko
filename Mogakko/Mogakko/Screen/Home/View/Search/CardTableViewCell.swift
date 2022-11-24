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

protocol CardTableViewCellDelegate: AnyObject {
    func touchUpMatchButton(_ indexPathRow: Int)
}

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
    
    // MARK: - UI Property
    
    var cardView = CardView().then {
        $0.isExpanded = false
        $0.cardViewType = .plain
    }
    
    var matchButton = MDSMatchButton().then {
        $0.type = .hidden
    }
    
    weak var delegate: CardTableViewCellDelegate?
    var indexPathRow = 0
    
    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        disposeBag = DisposeBag()
    }
    
    override func configureAttribute() {
        backgroundColor = .white
        configureButton()
        
//        matchButton.rx.tap
//            .skip(1)
//            .bind { [weak self] _ in
//                guard let self = self else { return }
//                self.tapMatchButton.onNext(true)
//            }
//            .disposed(by: disposeBag)
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
    
    // MARK: - Button
    
    private func configureButton() {
        matchButton.addTarget(self, action: #selector(touchUpMatchButton), for: .touchUpInside)
    }
    
    @objc func touchUpMatchButton() {
        delegate?.touchUpMatchButton(indexPathRow)
    }
}
