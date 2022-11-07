//
//  AuthorizationViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/07.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class AuthorizationViewController: UIViewController {
    
    // MARK: - Property
    
    

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureAttribute()
        bind()
    }
}

extension AuthorizationViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        
    }
    
    func configureAttribute() {
        view.backgroundColor = .white
    }
    
    func bind() {
        
    }
}
