//
//  URLConstantj.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/09.
//

import Foundation

enum Endpoint {
    
}

// MARK: - User

extension Endpoint {
    struct User {
        static let user = "/v1/user" // 로그인, 회원가입
        
        static let withDraw = "/v1/user/withdraw" // 회원 탈퇴
        static let updateFcmToken = "/v1/user/update_fcm_token" // FCM토큰 갱신
        static let mypage = "/v1/user/mypage" // 내 정보 수정 
    }
}

// MARK: - Queue

extension Endpoint {
    struct Queue {
        static let queue = "/v1/queue" // 새싹 찾기 요청
        
        static let search = "/v1/queue/search" // 주변 새싹 탐색
        static let myQueueState = "/v1/queue/myQueueState" // 내 상태
        
        static let studyRequest = "/v1/queue/studyrequest"
        static let studyAccept = "/v1/queue/studyaccept"
        static let dodge = "/v1/queue/dodge"
    }
}

// MARK: - Chat

extension Endpoint {
    struct Chat {
        static let chat = "/v1/chat"
        static let lastchatDate = "/v1/chat"
    }
}
