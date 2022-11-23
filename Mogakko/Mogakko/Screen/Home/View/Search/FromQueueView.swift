//
//  FromQueueView.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/19.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class FromQueueView: BaseView {
    
    // MARK: - UI Property
    
    var tableView = UITableView()
    
    var emptyView = SearchSesacEmptyView()
    
    // MARK: - Property
    
    var list: [FromQueue] = [] {
        didSet {
            if list.isEmpty {
                emptyView.isHidden = false
                tableView.isHidden = true
                
                emptyView.title = "아쉽게도 주변에 새싹이 없어요ㅠ"
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
        
//        fromQueueRelay
//            .skip(1)
//            .bind(to: tableView.rx.items(cellIdentifier: CardTableViewCell.reuseIdentifier, cellType: CardTableViewCell.self)) { [weak self] (row, element, cell) in
//                guard let self = self else {
//                    print("문제인가?")
//                    return
//
//                }
//                guard let cell = self.tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.reuseIdentifier) as? CardTableViewCell else {
//                    print("이것이 문제인가??")
//                    return
//                }
//                cell.isExpanded = true
//                cell.matchButtonType = .propose
//                print("========= 데이터는 잘 들어오나 ??? ", element)
////                cell.queue = element
//                cell.cardView.imageItem.accept(ImageItem(background: element.background, sesac: element.sesac))
//                cell.cardView.cardItem.accept(CardItem(nickname: element.nick, reputation: element.reputation, comment: element.reviews, studyList: element.studylist))
//            }
//            .disposed(by: disposeBag)
    }
}

extension FromQueueView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.reuseIdentifier, for: indexPath) as? CardTableViewCell else { return UITableViewCell() }
        let data = list[indexPath.row]
        cell.isExpanded = true
        cell.matchButtonType = .propose
        
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
