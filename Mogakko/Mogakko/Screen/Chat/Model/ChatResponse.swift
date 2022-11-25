//
//  Chat.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/25.
//

import Foundation

// MARK: - ChatResponse

struct ChatResponse: Codable {
    let payload: [Chat]
}

// MARK: - Chat

struct Chat: Codable {
    let id, to, from, chat: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case to, from, chat, createdAt
    }
}
