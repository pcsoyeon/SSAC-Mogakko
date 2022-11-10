//
//  NicknameViewModel.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/08.
//

import Foundation

import RxCocoa
import RxSwift

final class NicknameViewModel {
    
    struct Input {
        let nicknameTextFieldText: ControlProperty<String?>
        let buttonTap: ControlEvent<Void>
    }
    
    struct Output {
        let buttonType: Observable<MDSButtonType>
        let nicknameTextFieldSignal: Signal<Bool>
        let buttonTap: ControlEvent<Void>
    }
    
    func transform(from input: Input) -> Output {
        let buttonType = input.nicknameTextFieldText.orEmpty
            .map { $0.count <= 10 && $0.count > 0 ? MDSButtonType.fill : MDSButtonType.disable}
        
        let nicknameTextFieldSignal = input.nicknameTextFieldText.orEmpty
            .map { $0.count <= 10 }
            .asSignal(onErrorJustReturn: false)
        
        return Output(buttonType: buttonType, nicknameTextFieldSignal: nicknameTextFieldSignal, buttonTap: input.buttonTap)
    }
}
