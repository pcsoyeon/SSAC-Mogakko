//
//  Person.swift
//  Mogakko
//
//  Created by 소연 on 2022/12/02.
//

import Foundation

import RealmSwift

class Person: Object {
    @Persisted var uid: String
    @Persisted var chat: List<ChatDB>
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(uid: String) {
        self.init()
        self.uid = uid
    }
}
