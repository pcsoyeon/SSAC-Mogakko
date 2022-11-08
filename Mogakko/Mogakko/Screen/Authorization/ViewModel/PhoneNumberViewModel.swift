//
//  PhoneNumberViewModel.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/08.
//

import Foundation

import RxCocoa
import RxSwift

final class PhoneNumberViewModel {
    
    var phoneNumber = BehaviorRelay<String>(value: "")
    var isValid = BehaviorRelay<Bool>(value: false)
    
    func changePhoneNumber(_ number: String) {
        phoneNumber.accept(phoneNumber.value.count <= 12
                           ? phoneNumber.value.toPhoneNumberPattern(pattern: "###-###-####", replacmentCharacter: "#")
                           : phoneNumber.value.toPhoneNumberPattern(pattern: "###-####-####", replacmentCharacter: "#"))
        
        isValid.accept(phoneNumber.value.count >= 12 ? true : false)
        
    }
    
    func makeRequestPhoneNumber(_ number: String) -> String {
        if number != "" {
            let phoneNumber = number.replacingOccurrences(of: "-", with: "")
            let startIdx = phoneNumber.index(phoneNumber.startIndex, offsetBy: 1)
            let result = String(phoneNumber[startIdx...])
            return "+\(82)\(result)"
        } else {
            return "error"
        }
    }
}
