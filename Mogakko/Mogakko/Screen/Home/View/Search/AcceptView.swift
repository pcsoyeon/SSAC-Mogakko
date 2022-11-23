//
//  RequestedView.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/19.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class AcceptView: BaseView {
    
    // MARK: - UI Property
    
    private var tableView = UITableView()
    
    var emptyView = SearchSesacEmptyView()
    
    // MARK: - Property
    
    var list: [FromQueue] = [] {
        didSet {
            if list.isEmpty {
                emptyView.isHidden = false
                tableView.isHidden = true
                
                emptyView.title = "아직 받은 요청이 없어요ㅠ"
                emptyView.subtitle = "스터디를 변경하거나 조금만 더 기다려주세요!"
            } else {
                emptyView.isHidden = true
                tableView.isHidden = false
                tableView.reloadData()
            }
        }
    }
    
    var fromQueueRelay = BehaviorRelay<[FromQueue]>(value: [FromQueue(uid: "", nick: "", lat: 0.0, long: 0.0, reputation: [], studylist: [], reviews: [], gender: 0, type: 0, sesac: 0, background: 0)])
    
    
    var tapMatchButton = BehaviorRelay(value: "")
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Method
    
    override func configureHierarchy() {
        addSubviews(emptyView, tableView)
        
        tableView.snp.makeConstraints { make in
            make.verticalEdges.horizontalEdges.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview()
        }
    }
    
    override func configureAttribute() {
        backgroundColor = .white
        bind()
    }
    
    func bind() {
        tableView.register(CardTableViewCell.self, forCellReuseIdentifier: CardTableViewCell.reuseIdentifier)
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension AcceptView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.reuseIdentifier, for: indexPath) as? CardTableViewCell else { return UITableViewCell() }
        let data = list[indexPath.row]
        cell.isExpanded = true
        cell.matchButtonType = .accept
        
        cell.cardView.imageItem.accept(ImageItem(background: data.background, sesac: data.sesac))
        cell.cardView.cardItem.accept(CardItem(nickname: data.nick, reputation: data.reputation, comment: data.reviews, studyList: data.studylist))
        
        cell.tapMatchButton
            .withUnretained(self)
            .bind { view, isTapped in
                if isTapped { view.tapMatchButton.accept(data.uid) }
            }
            .disposed(by: cell.disposeBag)
        
        return cell
    }
}

