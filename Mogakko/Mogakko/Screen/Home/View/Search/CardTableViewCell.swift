//
//  CardTableViewCell.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/19.
//

import UIKit

import SnapKit
import Then

final class CardTableViewCell: BaseTableViewCell {
    
    // MARK: - Property
    
    var queue: FromQueue = FromQueue(uid: "", nick: "", lat: 0, long: 0, reputation: [], studylist: [], reviews: [], gender: 0, type: 0, sesac: 0, background: 0) {
        didSet {
            cardView.imageItem = ImageItem(background: queue.background, sesac: queue.sesac)
            
            cardView.cardItem = CardItem(nickname: queue.nick, reputation: queue.reputation, comment: queue.reviews, studyList: queue.studylist)
        }
    }
    
    var isExpanded: Bool = false {
        didSet {
            cardView.isExpanded = isExpanded
        }
    }
    
    var matchButtonType: MDSMatchType = .hidden {
        didSet {
            cardView.matchType = .accept
        }
    }
    
    // MARK: - UI Property
    
    private var cardView = CardView().then {
        $0.isExpanded = false
        $0.cardViewType = .plain
    }
    
    override func configureAttribute() {
        backgroundColor = .white
    }
    
    override func configureHierarchy() {
        addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.verticalEdges.horizontalEdges.equalToSuperview()
        }
    }
}
