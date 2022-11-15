//
//  InfoManangementViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/13.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class InfoManagementViewController: UIViewController {
    
    // MARK: - UI Property
    
    private lazy var navigationBar = MDSNavigationBar(self).then {
        $0.backButtonIsHidden = false
        $0.title = "정보 관리"
    }
    
    private var saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = MDSFont.Title3_M14.font
    }
    
    private lazy var tableView = UITableView()
    
    // MARK: - Property
    
    private let viewModel = InfoManagementViewModel()
    private let disposeBag = DisposeBag()
    
    private var isExpanded = false
    private var items = [InfoManagementItem]()
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setItem()
        
        configureHierarchy()
        configureAttribute()
        bind()
    }
}

extension InfoManagementViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        view.addSubviews(navigationBar, tableView)
        navigationBar.addSubview(saveButton)
        
        navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        saveButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(Metric.margin)
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
    
    private func setItem() {
        let background = ImageItem(background: 1, sesac: 1)
        let card = CardItem(nickname: "", review: "")
        let gender = GenderItem(gender: 1)
        let study = StudyItem(study: "")
        let allow = AllowSearchItem(searchable: 0)
        let age = AgeItem(ageMin: 18, ageMax: 35)
        let withdraw = WithdrawItem()
        
        items.append(background)
        items.append(card)
        items.append(gender)
        items.append(study)
        items.append(allow)
        items.append(age)
        items.append(withdraw)
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(InfoImageTableViewCell.self, forCellReuseIdentifier: InfoImageTableViewCell.reuseIdentifier)
        tableView.register(CardTableViewCell.self, forCellReuseIdentifier: CardTableViewCell.reuseIdentifier)
        tableView.register(GenderTableViewCell.self, forCellReuseIdentifier: GenderTableViewCell.reuseIdentifier)
        tableView.register(StudyTableViewCell.self, forCellReuseIdentifier: StudyTableViewCell.reuseIdentifier)
        tableView.register(AllowSearchTableViewCell.self, forCellReuseIdentifier: AllowSearchTableViewCell.reuseIdentifier)
        tableView.register(AgeTableViewCell.self, forCellReuseIdentifier: AgeTableViewCell.reuseIdentifier)
        tableView.register(WithdrawTableViewCell.self, forCellReuseIdentifier: WithdrawTableViewCell.reuseIdentifier)
    }
    
    func bind() {
        saveButton.rx.tap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { vc, _ in
                vc.updateMypage()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableView Protocol

extension InfoManagementViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            isExpanded.toggle()
            tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .fade)
        } else if indexPath.section == 6 {
            print("회원 탈퇴")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 210 : (indexPath.section == 1 ? (isExpanded ? UITableView.automaticDimension : 58) : 80)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        
        switch item.type {
        case .background:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoImageTableViewCell.reuseIdentifier, for: indexPath) as? InfoImageTableViewCell else { return UITableViewCell() }
            cell.item = ImageItem(background: 1, sesac: 1)
            cell.selectionStyle = .none
            return cell
            
        case .card:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.reuseIdentifier, for: indexPath) as? CardTableViewCell else { return UITableViewCell() }
            cell.item = CardItem(nickname: "소연이넘자식", review: "리뷰가들어가는공간입니다람쥐")
            cell.selectionStyle = .none
            return cell
            
        case .gender:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GenderTableViewCell.reuseIdentifier, for: indexPath) as? GenderTableViewCell else { return UITableViewCell() }
            cell.item = GenderItem(gender: 1)
            cell.selectionStyle = .none
            return cell
            
        case .study:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StudyTableViewCell.reuseIdentifier, for: indexPath) as? StudyTableViewCell else { return UITableViewCell() }
            cell.item = StudyItem(study: "알고리즘")
            cell.selectionStyle = .none
            return cell
            
        case .allow:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AllowSearchTableViewCell.reuseIdentifier, for: indexPath) as? AllowSearchTableViewCell else { return UITableViewCell() }
            cell.item = AllowSearchItem(searchable: 1)
            cell.selectionStyle = .none
            return cell
            
        case .age:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AgeTableViewCell.reuseIdentifier, for: indexPath) as? AgeTableViewCell else { return UITableViewCell() }
            cell.item = AgeItem(ageMin: 18, ageMax: 35)
            cell.selectionStyle = .none
            return cell
            
        case .withdraw:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WithdrawTableViewCell.reuseIdentifier, for: indexPath) as? WithdrawTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            return cell
        }
    }
}

// MARK: - Network

extension InfoManagementViewController {
    private func updateMypage() {
        let param = MypageRequest(searchable: 1, ageMin: 20, ageMax: 35, gender: 0, study: "Jack&Hue \(Int.random(in: 1...100))")
        let router = UserRouter.mypage(mypageRequest: param)
        
        GenericAPI.shared.requestData(router: router) { [weak self] response in
            guard let self = self else { return }
            
            switch response {
            case .success(_):
                self.showToast(message: "내 정보 업데이트!")
                self.navigationController?.popViewController(animated: true)
                
            case .failure(let error):
                switch error {
                case .takenUser:
                    return
                case .invalidNickname:
                    return
                case .invalidAuthorization:
                    print("Firebase Token Error")
                case .unsubscribedUser:
                    print("미가입 회원/탈퇴 성공")
                case .serverError:
                    print("서버 내부 에러")
                case .emptyParameters:
                    print("클라 요청 에러")
                }
            }
        }
    }
    
}
