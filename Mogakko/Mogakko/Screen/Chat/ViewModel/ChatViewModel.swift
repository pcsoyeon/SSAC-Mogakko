//
//  ChatViewModel.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/24.
//

import Foundation

import RxCocoa
import RxSwift

final class ChatViewModel: BaseViewModel {
    
    var queue = BehaviorRelay(value: FromQueue(uid: "", nick: "", lat: 0.0, long: 0.0, reputation: [], studylist: [], reviews: [], gender: 0, type: 0, sesac: 0, background: 0))
}
