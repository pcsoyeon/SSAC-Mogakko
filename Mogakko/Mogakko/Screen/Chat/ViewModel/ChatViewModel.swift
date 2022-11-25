//
//  ChatViewModel.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/24.
//

import Foundation

import RxCocoa
import RxDataSources
import RxSwift

struct ChatSection {
    var header: Int
    var items: [Item]
}

extension ChatSection: SectionModelType {
    typealias Item = Chat
    
    init(original: ChatSection, items: [Item]) {
        self = original
        self.items = items
    }
}

final class ChatViewModel: BaseViewModel {
    var uid = BehaviorRelay(value: "")
    var nick = BehaviorRelay(value: "")
    
    var chatList: [Chat] = []
    lazy var chatRelay = BehaviorRelay<[ChatSection]>(value: [
        ChatSection(header: 0, items: [Chat(id: "", v: 0, to: "", from: "", chat: self.nick.value, createdAt: "아마도날짜")]),
        ChatSection(header: 1, items: [Chat(id: "huree", v: 0, to: "", from: "", chat: "방구머겅", createdAt: "05:30"),
                               Chat(id: "sokyte", v: 0, to: "", from: "", chat: "방구??!?!?너지금방구라그랬냐!?!!?!어?!?!!?!!??!?", createdAt: "05:30"),
                               Chat(id: "huree", v: 0, to: "", from: "", chat: "똥칼라파워", createdAt: "05:30")
        ])
    ])
}

