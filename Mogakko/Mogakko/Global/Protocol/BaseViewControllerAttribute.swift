//
//  BaseViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/07.
//

import Foundation

protocol BaseViewControllerAttribute {
    func configureHierarchy()
    func configureAttribute()
    func bind()
}
