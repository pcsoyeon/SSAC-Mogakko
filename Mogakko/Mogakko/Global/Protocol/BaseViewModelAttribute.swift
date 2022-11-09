//
//  BaseViewModelAttribute.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/09.
//

import Foundation

protocol BaseViewModelAttribute {
    associatedtype Input
    associatedtype Output
    
    func transform(from input: Input) -> Output
}
