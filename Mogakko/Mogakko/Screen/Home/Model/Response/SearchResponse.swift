//
//  SearchResponse.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/17.
//

import Foundation

// MARK: - SearchResponse

struct SearchResponse: Codable {
    let fromQueueDB, fromQueueDBRequested: [FromQueue]
    let fromRecommend: [String]
}

// MARK: - FromQueueDB

struct FromQueue: Codable {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let studylist, reviews: [String]
    let gender, type, sesac, background: Int
}
