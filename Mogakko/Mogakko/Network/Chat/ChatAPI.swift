//
//  ChatAPI.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/25.
//

import Foundation

import Alamofire

final class ChatAPI {
    static let shared = ChatAPI()
    
    private init() { }
    
    func postChat(to: String, chat: String, completionHandler: @escaping (Int) -> Void) {
        AF.request(ChatRouter.chat(to: to, chat: chat))
            .validate(statusCode: 200...500)
            .responseData { response in
                switch response.result {
                case .success(_):
                    guard let statusCode = response.response?.statusCode else { return }
                    completionHandler(statusCode)
                    
                case .failure(_):
                    guard let statusCode = response.response?.statusCode else { return }
                    completionHandler(statusCode)
                }
            }
    }
    
    func requestChatList(from: String, lastchatDate: String, completionHandler: @escaping (ChatResponse?, Int?) -> Void){
        AF.request(ChatRouter.lastchatDate(from: from, date: lastchatDate))
            .validate(statusCode: 200...500)
            .responseDecodable(of: ChatResponse.self) { response in
                print(response)
                switch response.result {
                case .success(let data):
                    print(data)
                    completionHandler(data, nil)
                    
                case .failure(_):
                    guard let statusCode = response.response?.statusCode else { return }
                    completionHandler(nil, statusCode)
                }
            }
    }
}
