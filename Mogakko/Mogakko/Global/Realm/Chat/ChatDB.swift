//
//  Chat.swift
//  Mogakko
//
//  Created by 소연 on 2022/12/02.
//

import Foundation

import RealmSwift

class ChatDB: Object {
    @Persisted var id: String
    @Persisted var chat: String
    @Persisted var createdAt: Date
    @Persisted var from: String
    @Persisted var to: String
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(id: String, chat: String, createdAt: Date, from: String, to: String) {
        self.init()
        self.id = id
        self.chat = chat
        self.createdAt = createdAt
        self.from = from
        self.to = to
    }
}
