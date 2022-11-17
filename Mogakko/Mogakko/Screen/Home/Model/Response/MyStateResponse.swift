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
   "matchedNick": "고래밥",
   "matchedUid": "x4r4tjQZ8Pf9mFYUgkfmC4REcvu2"
 }
 */

struct MyStateResponse: Codable {
    var dodged: Int
    var matched: Int
    var reviewed: Int
    var matchedNick: String
    var matchedUid: String
}
