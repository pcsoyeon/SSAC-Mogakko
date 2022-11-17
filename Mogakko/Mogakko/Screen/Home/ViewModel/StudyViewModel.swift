//
//  StudyViewModel.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/17.
//

import Foundation

import RxCocoa
import RxSwift

final class StudyViewModel {
    
    // MARK: - Property
    
    var recommend = BehaviorRelay<[String]>(value: [])
    var selectedList = BehaviorRelay<[String]>(value: [])
    
    // MARK: - UI Method
}
