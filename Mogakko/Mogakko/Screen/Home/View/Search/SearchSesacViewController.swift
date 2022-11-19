//
//  SearchSesacViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/19.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class SearchSesacViewController: UIViewController {
    
    // MARK: - UI Property
    
    private lazy var navigationBar = MDSNavigationBar(self).then {
        $0.backButtonIsHidden = false
        $0.title = "새싹 찾기"
    }
    
    private var saveButton = UIButton().then {
        $0.setTitle("찾기중단", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = MDSFont.Title3_M14.font
    }
    
    // MARK: - Property
    
    private let viewModel = SearchSesacViewModel()
    private let disposeBag = DisposeBag()
    
    var mapLatitude = 0.0
    var mapLongitude = 0.0
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAttribute()
        configureHierarchy()
        bind()
    }
}

extension SearchSesacViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        
    }
    
    func configureAttribute() {
        view.backgroundColor = .white
    }
    
    func bind() {
        viewModel.requestSearch(request: SearchRequest(lat: mapLatitude, long: mapLongitude)) { error in
            if let error = error {
                print("error - \(error.errorDescription ?? "")")
            }
        }
        
        viewModel.fromQueue
            .bind { list in
                print("============ 주변 새싹 ============")
                dump(list)
            }
            .disposed(by: disposeBag)
        
        viewModel.fromRequestedQueue
            .bind { list in
                print("============ 스터디를 요청한 새싹 ============")
                dump(list)
            }
            .disposed(by: disposeBag)
    }
}
