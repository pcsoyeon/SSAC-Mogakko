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
        static let withDraw = "/v1/user/withdraw"
        static let updateFcmToken = "/v1/user/update_fcm_token"
    }
}
