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
//    var uid = BehaviorRelay(value: "")
//    var nick = BehaviorRelay(value: "")
    
    var uid: String = ""
    var nick: String = ""
    
    var chatList: [Chat] = []
    lazy var chatRelay = BehaviorRelay<[ChatSection]>(value: [
        ChatSection(header: 0, items: [Chat(id: "", to: "", from: "", chat: self.nick, createdAt: "")]),
        ChatSection(header: 1, items: [])
    ])
    
    private var dateFormatter = DateFormatter()
    
    func appendChatToSection(_ chat: Chat) {
        let chat = Chat(id: chat.id, to: chat.to, from: chat.from, chat: chat.chat, createdAt: toChatString(dateFormatter.date(from: chat.createdAt)!))
        chatList.append(chat)
        let chatSection = [ChatSection(header: 0, items: [Chat(id: "", to: "", from: "", chat: nick, createdAt: "1월 15일 토요일")]),
                           ChatSection(header: 1, items: chatList)]
        
        chatRelay.accept(chatSection)
    }
    
    func requestChatList(lastchatDate: String, completionHandler: @escaping (Int) -> Void) {
        ChatAPI.shared.requestChatList(from: uid, lastchatDate: lastchatDate) { [weak self] response, statusCode in
            guard let self = self else { return }
            
            self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            self.dateFormatter.timeZone = TimeZone(identifier: "UTC")
            
            if let response = response {
                dump(response)
                
                let payload = response.payload
                var chatList: [Chat] = []
                payload.forEach {
                    let date:Date = self.dateFormatter.date(from: $0.createdAt)!
                    let dateString: String = self.toChatString(date)
                    chatList.append(Chat(id: $0.id, to: $0.to, from: $0.from, chat: $0.chat, createdAt: dateString))
                }
                self.chatList = chatList
                
                let chatSection = [ChatSection(header: 0, items: [Chat(id: "", to: "", from: "", chat: self.nick, createdAt: "1월 15일 토요일")]),
                                   ChatSection(header: 1, items: chatList)]
                
                self.chatRelay.accept(chatSection)
                completionHandler(200)
                return
            }
            
            if let statusCode = statusCode {
                completionHandler(statusCode)
                return
            }
        }
    }
    
    private func toChatString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        
        var current = Calendar.current
        current.locale = Locale(identifier: "ko-KR")
        
        if current.isDateInToday(date) {
            dateFormatter.dateFormat = "a hh:mm"
            return dateFormatter.string(from: date)
        } else {
            dateFormatter.dateFormat = "M/dd a hh:mm"
            return dateFormatter.string(from: date)
        }
    }
    
    func postChat(text: String, completionHandler: @escaping (Int) -> Void) {
        ChatAPI.shared.postChat(to: uid, chat: text) { [weak self] response, statusCode in
            guard let self = self else { return }
            guard let statusCode = statusCode else { return }
            print("============== 채팅을 보냈어요💨 \(statusCode)")
            
            completionHandler(200)
            
            if let response = response {
                dump(response)
                
                let chat: Chat = Chat(id: response.id, to: response.to, from: response.from, chat: response.chat, createdAt: self.toChatString(self.dateFormatter.date(from: response.createdAt)!))
                
                UserData.uid = response.from
                
                self.chatList.append(chat)
                let chatSection = [ChatSection(header: 0, items: [Chat(id: "", to: "", from: "", chat: self.nick, createdAt: "1월 15일 토요일")]),
                                   ChatSection(header: 1, items: self.chatList)]
                
                self.chatRelay.accept(chatSection)
            }
        }
    }
    
    func requestMyState(completionHandler: @escaping (MyStateResponse?, APIError?) -> Void) {
        GenericAPI.shared.requestDecodableData(type: MyStateResponse.self, router: QueueRouter.myQueueState) { [weak self] response in
            guard let self = self else { return }
            
            switch response {
            case .success(let data):
                
                self.uid = data.matchedUid ?? ""
                self.nick = data.matchedNick ?? ""
                
                completionHandler(data, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
}

