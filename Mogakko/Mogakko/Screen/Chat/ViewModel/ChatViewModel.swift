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
        ChatSection(header: 0, items: [Chat(id: "", to: "", from: "", chat: self.nick.value, createdAt: "아마도날짜")]),
        ChatSection(header: 1, items: [])
    ])
    
    func requestChatList(from: String, lastchatDate: String, completionHandler: @escaping (Int) -> Void) {
        ChatAPI.shared.requestChatList(from: from, lastchatDate: lastchatDate) { [weak self] response, statusCode in
            guard let self = self else { return }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            
            if let response = response {
                
                let payload = response.payload
                var chatList: [Chat] = []
                payload.forEach {
                    let date:Date = dateFormatter.date(from: $0.createdAt)!
                    let dateString: String = date.toChatString()
                    chatList.append(Chat(id: $0.id, to: $0.to, from: $0.from, chat: $0.chat, createdAt: dateString))
                }
                
                let chatSection = [ChatSection(header: 0, items: [Chat(id: "", to: "", from: "", chat: self.nick.value, createdAt: "")]),
                                   ChatSection(header: 1, items: chatList)]
                
                self.chatRelay.accept(chatSection)
                completionHandler(200)
            }
            
            if let statusCode = statusCode {
                completionHandler(statusCode)
            }
        }
    }
}

