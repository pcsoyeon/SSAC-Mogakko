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
    
    // MARK: - Property
    
    var timer: Timer!
    var limitTime = 60
    
    var timerString = BehaviorRelay<String>(value: "")
    var isTimerValid = BehaviorRelay<Bool>(value: true)
    
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
    
    // MARK: - Helper
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            self.limitTime -= 1
            self.updateTimerLabel()
        })
    }
    
    private func updateTimerLabel() {
        let minutes = self.limitTime / 60
        let seconds = self.limitTime % 60
        
        if self.limitTime > 0 {
            timerString.accept(String(format: "%02d:%02d", minutes, seconds))
        } else {
            isTimerValid.accept(false)
            self.timer.invalidate()
        }
    }
    
    private func stopTimer() {
        timer.invalidate()
        limitTime = 60
    }
}
