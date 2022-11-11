//
//  PhoneNumberViewModel.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/08.
//

import Foundation

import FirebaseAuth
import RxCocoa
import RxSwift

final class PhoneNumberViewModel: BaseViewModelAttribute {
    
    // MARK: - Property
    
    var isValid = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Input, Output
    
    struct Input {
        // property
        let numberTextFieldText: ControlProperty<String?>
        
        // event
        let buttonTap: ControlEvent<Void>
    }
    
    struct Output {
        // property
        let phoneNumber: Observable<String>
        let isValid: Signal<Bool>
        
        // event
        let buttonTap: ControlEvent<Void>
    }
    
    func transform(from input: Input) -> Output {
        let phoneNumber = input.numberTextFieldText.orEmpty
            .withUnretained(self)
            .map { vm, text in
                text.count <= 12 ? text.toPhoneNumberPattern(pattern: "###-###-####", replacmentCharacter: "#") : text.toPhoneNumberPattern(pattern: "###-####-####", replacmentCharacter: "#")
            }
        
        let isValid = input.numberTextFieldText.orEmpty
            .map { text in
                let phoneNumRegex = "[0-1]{3}[-]+[0-9]{3,4}[-]+[0-9]{4}"
                let pred = NSPredicate(format:"SELF MATCHES %@", phoneNumRegex)
                return pred.evaluate(with: text)
            }
            .asSignal(onErrorJustReturn: false)
        
        return Output(phoneNumber: phoneNumber,
                      isValid: isValid,
                      buttonTap: input.buttonTap)
    }
    
    // MARK: - Method
    
    func makeRequestPhoneNumber(_ number: String) -> String {
        if number != "" {
            let phoneNumber = number.replacingOccurrences(of: "-", with: "")
            let startIdx = phoneNumber.index(phoneNumber.startIndex, offsetBy: 1)
            let result = String(phoneNumber[startIdx...])
            return "+\(82)\(result)"
        } else {
            return ""
        }
    }
    
    func requestVerificationCode(phoneNumber: String, completion: @escaping (String?, Error?) -> Void) {
        Auth.auth().languageCode = "ko"
        
        let phoneNumber = makeRequestPhoneNumber(phoneNumber)
        UserDefaults.standard.set(phoneNumber, forKey: Constant.UserDefaults.phoneNumber)
        
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                guard let error = error else {
                    completion(verificationID, nil)
                    return
                }
                completion(nil, error)
            }
    }
}
