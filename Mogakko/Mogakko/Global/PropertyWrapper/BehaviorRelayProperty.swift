//
//  BehaviorRelayProperty.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/18.
//

import Foundation

import RxCocoa
import RxSwift

@propertyWrapper
struct BehaviorRelayProperty<Value> {
    private var subject: BehaviorRelay<Value>
    public var wrappedValue: Value {
        get { subject.value }
        set { subject.accept(newValue) }
    }
    
    public var projectedValue: BehaviorRelay<Value> {
        return self.subject
    }
    
    public init(wrappedValue: Value) {
        subject = BehaviorRelay(value: wrappedValue)
    }
}
