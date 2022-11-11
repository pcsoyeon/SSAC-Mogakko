//
//  BirthViewModel.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/08.
//

import Foundation

import RxCocoa
import RxSwift

final class BirthViewModel: BaseViewModelAttribute {
    
    // MARK: - Input/Ouput
    
    struct Input {
        let datePickerDate: ControlProperty<Date>
        let nextButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let nextButtonTap: ControlEvent<Void>
        
        let year: Observable<String>
        let month: Observable<String>
        let date: Observable<String>
        
        let isValid: Observable<Bool>
    }
    
    func transform(from input: Input) -> Output{
        let year = input.datePickerDate
            .map { value in
                let yearFormatter = DateFormatter()
                yearFormatter.dateFormat = "yyyy"
                return yearFormatter.string(from: value)
            }
        
        let month = input.datePickerDate
            .map { value in
                let monthFormatter = DateFormatter()
                monthFormatter.dateFormat = "MM"
                return monthFormatter.string(from: value)
            }

        let day = input.datePickerDate
            .map { value in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd"
                return dateFormatter.string(from: value)
            }
        
        let isValid = input.datePickerDate
            .map { value in
                let calendar = Calendar.current
                let ageComponents = calendar.dateComponents([.year], from: value, to: Date())
                let age = ageComponents.year!
                
                if age >= 17 {
                    return true
                } else {
                    return false
                }
            }
        
        return Output(nextButtonTap: input.nextButtonTap, year: year, month: month, date: day, isValid: isValid)
    }
}
