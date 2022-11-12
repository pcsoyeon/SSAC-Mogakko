//
//  APIError.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/12.
//

import Foundation

@frozen
enum APIError: Int, Error {
    case takenUser = 201
    case invalidNickname = 202
    case invalidAuthorization = 401
    case unsubscribedUser = 406
    case serverError = 500
    case emptyParameters = 501
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .takenUser:
            return "이미 가입한 유저입니다."
        case .invalidNickname:
            return "유효하지 않은 닉네임입니다."
        case .invalidAuthorization:
            return "토큰이 만료되었습니다. 다시 로그인 해주세요."
        case .unsubscribedUser:
            return "아직 가입하지 않은 유저입니다."
        case .serverError:
            return "서버 에러입니다. 잠시 후 이용해주세요."
        case .emptyParameters:
            return "request header/body를 확인해주세요."
        }
    }
}
