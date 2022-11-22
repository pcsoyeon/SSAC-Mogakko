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
//                cell.cardView.imageItem = ImageItem(background: element.background, sesac: element.sesac)
//                cell.cardView.cardItem = CardItem(nickname: element.nick, reputation: element.reputation, comment: element.reviews)
//            }
//            .disposed(by: disposeBag)
//
//        Observable.zip(tableView.rx.modelSelected(FromQueue.self),
//                       tableView.rx.itemSelected)
//        .bind { [weak self] (item, indexPath) in
//            guard let self = self else { return }
//            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.reuseIdentifier, for: indexPath) as? CardTableViewCell else { return }
//            cell.isExpanded.toggle() // toggle은 되는데 UI 업데이트가 되지 않는 이슈 ...
//            cell.cardView.matchButtonTap
//                .bind { uid in
//                    print("💍 \(uid)")
//                }
//                .disposed(by: cell.disposeBag)
//        }
//        .disposed(by: disposeBag)
    }
}

extension FromQueueView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.reuseIdentifier, for: indexPath) as? CardTableViewCell else { return UITableViewCell() }
        let data = list[indexPath.row]
        cell.cardView.cardItem = CardItem(nickname: data.nick, reputation: data.reputation, comment: data.reviews)
        cell.cardView.imageItem = ImageItem(background: data.background, sesac: data.sesac)
        
        cell.isExpanded = true
        cell.matchButtonType = .propose
        
        cell.matchButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] in
                self?.tapMatchButton.accept(data.uid)
            })
            .disposed(by: cell.disposeBag)
        
        return cell
    }
}
