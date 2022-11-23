//
//  StateResponse.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/17.
//

import Foundation

/*
 {
   "dodged": 0,
   "matched": 1,
   "reviewed": 0,
   "matchedNick": "고래밥", // key가 없을 수 있다.
   "matchedUid": "x4r4tjQZ8Pf9mFYUgkfmC4REcvu2" // key가 없을 수 있다.
 }
 */

struct MyStateResponse: Codable {
    var dodged: Int
    var matched: Int
    var reviewed: Int
    var matchedNick: String?
    var matchedUid: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.dodged = try container.decodeIfPresent(Int.self, forKey: .dodged) ?? 0
        self.matched = try container.decodeIfPresent(Int.self, forKey: .matched) ?? 0
        self.reviewed = try container.decodeIfPresent(Int.self, forKey: .reviewed) ?? 0
        
        self.matchedNick = try container.decodeIfPresent(String.self, forKey: .matchedNick)
        self.matchedUid = try container.decodeIfPresent(String.self, forKey: .matchedUid)
    }
}
