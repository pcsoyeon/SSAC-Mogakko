//
//  HomeViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/11.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

class HomeViewController: UIViewController {

    // MARK: - UI Property
    
    private var withdrawButton = UIButton().then {
        $0.setTitle("탈퇴하기", for: .normal)
        $0.setTitleColor(.blue, for: .normal)
    }
    
    // MARK: - Property
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(withdrawButton)
        withdrawButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        withdrawButton.rx.tap
            .bind {
                UserAPI.shared.requestWithdraw { statusCode, error in
                    guard let statusCode = statusCode else { return }
                    print(statusCode)
                }
            }
            .disposed(by: disposeBag)
    }
}
