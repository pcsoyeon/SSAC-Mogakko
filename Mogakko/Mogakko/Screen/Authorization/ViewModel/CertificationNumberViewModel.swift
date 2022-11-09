//
//  CertificationViewModel.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/09.
//

import Foundation

import FirebaseAuth
import RxCocoa
import RxSwift

final class CertificationNumberViewModel {
    
    // MARK: - Input, Output
    
    struct Input {
        let numberTextFieldText: ControlProperty<String?>
        let buttonTap: ControlEvent<Void>
    }
    
    struct Output {
        let startButtonType: Observable<MDSButtonType>
        let numberTextFieldSignal: Signal<Bool>
        let buttonTap: ControlEvent<Void>
    }
    
    func transform(from input: Input) -> Output {
        let startButtonType = input.numberTextFieldText.orEmpty
            .map { $0.count < 7 && $0.count > 0 ? MDSButtonType.fill : MDSButtonType.disable}
        let numberTextFieldSingal = input.numberTextFieldText.orEmpty.map { $0.count < 7 }
            .asSignal(onErrorJustReturn: false)
        
        return Output(startButtonType: startButtonType,
                      numberTextFieldSignal: numberTextFieldSingal,
                      buttonTap: input.buttonTap)
    }
}
