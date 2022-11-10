//
//  EmailViewModel.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/08.
//

import Foundation

import RxCocoa
import RxSwift

final class EmailViewModel {
    var isValid = BehaviorRelay<Bool>(value: false)
    
    struct Input {
        let emailTextFieldText: ControlProperty<String?>
        let buttonTap: ControlEvent<Void>
    }
    
    struct Output {
        let emailTextFieldText: ControlProperty<String>
        let buttonTap: ControlEvent<Void>
        let buttonType: Observable<MDSButtonType>
    }
    
    func transform(from input: Input) -> Output {
        let emailTextFieldText = input.emailTextFieldText.orEmpty
        
        let buttonType = input.emailTextFieldText.orEmpty.withUnretained(self).map { vm, text in
            vm.validateEmail(text) ? MDSButtonType.fill : MDSButtonType.disable
        }
        
        return Output(emailTextFieldText: emailTextFieldText, buttonTap: input.buttonTap, buttonType: buttonType)
    }
    
    func validateEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        isValid.accept(emailTest.evaluate(with: email))
        return emailTest.evaluate(with: email)
    }
}
