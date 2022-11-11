//
//  BirthViewModel.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/08.
//

import Foundation

import RxCocoa
import RxSwift

final class BirthViewModel {
    
    // MARK: - Property
    
    var yearRelay = BehaviorRelay<String>(value: "1990")
    var monthRelay = BehaviorRelay<String>(value: "1")
    var dateRelay = BehaviorRelay<String>(value: "1")
    
    var isValid = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Input/Ouput
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(from input: Input) {
        
    }
    
    // MARK: - Method
    
    func changeDateToString(_ date: Date) {
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        
        yearRelay.accept(yearFormatter.string(from: date))
        monthRelay.accept(monthFormatter.string(from: date))
        dateRelay.accept(dateFormatter.string(from: date))
    }
    
    func calculateAge(_ birthday: Date) {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: Date())
        let age = ageComponents.year!
        
        if age >= 17 {
            isValid.accept(true)
        } else {
            isValid.accept(false)
        }
    }
}
