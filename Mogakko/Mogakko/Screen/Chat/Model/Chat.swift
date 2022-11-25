//
//  Chat.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/25.
//

import Foundation

struct ChatList {
    let payload: [Chat]
}

struct Chat {
    let id: String
    let v: Int
    let to, from, chat, createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case v = "__v"
        case to, from, chat, createdAt
    }
}
