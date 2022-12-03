//
//  ChatRepository.swift
//  Mogakko
//
//  Created by 소연 on 2022/12/02.
//

import Foundation

import RealmSwift

protocol ChatRepositoryType {
    func addChat(chat: ChatDB)
    func fetchChatList() -> Results<ChatDB>
}

class ChatRepository: ChatRepositoryType {
    let localRealm = try! Realm()
    
    func addChat(chat: ChatDB) {
        do {
            try localRealm.write {
                localRealm.add(chat)
            }
        } catch let error {
            print(error)
        }
    }
    
    func fetchChatList() -> Results<ChatDB> {
        return localRealm.objects(ChatDB.self).sorted(byKeyPath: "createdAt", ascending: false)
    }
    
    func filterChatListByUid(uid: String) -> Results<ChatDB> {
        return localRealm.objects(ChatDB.self).where {
            ($0.from == uid) || ($0.to == uid)
        }.sorted(byKeyPath: "createdAt", ascending: false)
    }
}
