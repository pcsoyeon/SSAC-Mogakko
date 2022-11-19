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
    
    private var tableView = UITableView()
    
    // MARK: - Property
    
    var isEmpty: Bool = false {
        didSet {
            
        }
    }
    
    var list = BehaviorRelay<[FromQueue]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Method
    
    override func configureHierarchy() {
        addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.verticalEdges.horizontalEdges.equalToSuperview()
        }
    }
    
    override func configureAttribute() {
        backgroundColor = .white
        bind()
    }
    
    func bind() {
        tableView.register(QueueTableViewCell.self, forCellReuseIdentifier: QueueTableViewCell.reuseIdentifier)
        
        list.bind(to: tableView.rx.items) { (tableView: UITableView, index: Int, element: FromQueue) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: QueueTableViewCell.reuseIdentifier) as? QueueTableViewCell else { return UITableViewCell() }
            cell.queue = element
            return cell
        }
        .disposed(by: disposeBag)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
        tableView.rx.itemSelected
            .bind { indexPath in
                guard let cell = self.tableView.dequeueReusableCell(withIdentifier: QueueTableViewCell.reuseIdentifier) as? QueueTableViewCell else { return }
                cell.cardView.touchUpExpandButton.toggle()
                self.tableView.reloadRows(at: [IndexPath(item: indexPath.item, section: 0)], with: .fade)
            }
            .disposed(by: disposeBag)
    }
}

final class QueueTableViewCell: BaseTableViewCell {
    
    var cardView = CardView().then {
        $0.type = .plain
        $0.touchUpExpandButton = false
    }
    
    var queue: FromQueue = FromQueue(uid: "", nick: "", lat: 0, long: 0, reputation: [], studylist: [], reviews: [], gender: 0, type: 0, sesac: 0, background: 0) {
        didSet {
            cardView.imageItem = ImageItem(background: queue.background, sesac: queue.sesac)
            cardView.cardItem = CardItem(nickname: queue.nick, reputation: queue.reputation, comment: queue.reviews)
        }
    }
    
    override func configureAttribute() {
        contentView.addSubview(cardView)
        contentView.backgroundColor = .white
    }
    
    override func configureHierarchy() {
        contentView.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.verticalEdges.horizontalEdges.equalToSuperview()
        }
    }
}
