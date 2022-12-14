//
//  Reactive+Extension.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/16.
//

import UIKit

import RxSwift

// MARK: - Rx+UIViewController

extension Reactive where Base: UIViewController {
    var viewWillAppear: Observable<[Any]> {
        return sentMessage(#selector(UIViewController.viewWillAppear(_:)))
    }
    
    var viewDidAppear: Observable<[Any]> {
        return sentMessage(#selector(UIViewController.viewDidAppear(_:)))
    }
    
    var viewDidLoad: Observable<[Any]> {
        return sentMessage(#selector(UIViewController.viewDidLoad))
    }
}

// MARK: - Rx+SearchBar

extension Reactive where Base: UISearchBar {
    var endEditing: Binder<Void> {
        return Binder(base) { base, _ in
            base.endEditing(true)
        }
    }
}
