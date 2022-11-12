//
//  MyInfoViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/13.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class MyInfoViewController: UIViewController {
    
    // MARK: - UI Property
    
    private lazy var navigationBar = MDSNavigationBar(self).then {
        $0.backButtonIsHidden = true
        $0.title = "내정보"
    }
    
    private var tableView = UITableView()
    
    // MARK: - Property
    
    private let viewModel = MyInfoViewModel()
    
    private let disposeBag = DisposeBag()

    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureAttribute()
        bind()
    }
}

extension MyInfoViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        view.addSubviews(navigationBar, tableView)
        
        navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureAttribute() {
        view.backgroundColor = .white
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .white
        
        tableView.separatorColor = .gray2
        tableView.separatorInset = UIEdgeInsets(top: 0, left: Metric.margin, bottom: 0, right: Metric.margin)
        
        tableView.register(MyInfoHeaderTableViewCell.self, forCellReuseIdentifier: MyInfoHeaderTableViewCell.reuseIdentifier)
        tableView.register(MyInfoTableViewCell.self, forCellReuseIdentifier: MyInfoTableViewCell.reuseIdentifier)
    }
    
    func bind() {
        viewModel.info
            .asDriver()
            .drive(tableView.rx.items) { (tableView, row, item) -> UITableViewCell in
                if row == 0 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: MyInfoHeaderTableViewCell.reuseIdentifier, for: IndexPath(row: row, section: 0)) as? MyInfoHeaderTableViewCell else { return UITableViewCell() }
                    cell.setData(item)
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: MyInfoTableViewCell.reuseIdentifier, for: IndexPath(row: row, section: 0)) as? MyInfoTableViewCell else { return UITableViewCell() }
                    cell.setData(item)
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, indexPath in
                if indexPath.row == 0 {
                    // 화면 전환
                    let param = MypageRequest(searchable: 1, ageMin: 20, ageMax: 30, gender: 0, study: "Coding")
                    UserAPI.shared.requestMypage(mypage: param) { statusCode, error in
                        print("🥑 마이페이지 수정 상태코드 : \(statusCode)")
                    }
                }
                vc.tableView.deselectRow(at: indexPath, animated: false)
            })
            .disposed(by: disposeBag)
        
        tableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate
extension MyInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 96 : 74
    }
}
