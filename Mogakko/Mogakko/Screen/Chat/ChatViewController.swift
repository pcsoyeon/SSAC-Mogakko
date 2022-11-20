//
//  ChatViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/21.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class ChatViewController: UIViewController {
    
    // MARK: - UI Property
    

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureAttribute()
        bind()
    }
}

extension ChatViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        
    }
    
    func configureAttribute() {
        view.backgroundColor = .white
    }
    
    func bind() {
        
    }
}
