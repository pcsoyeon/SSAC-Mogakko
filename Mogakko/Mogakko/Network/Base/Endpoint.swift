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
    }
}
