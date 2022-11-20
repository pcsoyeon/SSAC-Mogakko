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
    
    private var emptyView = SearchSesacEmptyView()
    
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

extension FromQueueView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.reuseIdentifier, for: indexPath) as? CardTableViewCell else { return UITableViewCell() }
        cell.queue = list[indexPath.row]
        cell.isExpanded = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.reuseIdentifier, for: indexPath) as? CardTableViewCell else { return }
        cell.isExpanded.toggle()
        tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
    }
}
