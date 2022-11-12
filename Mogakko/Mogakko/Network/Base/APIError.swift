//
//  APIError.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/12.
//

import Foundation

enum APIError: Int, Error {
    case invalidAuthorization = 401
    case takenEmail = 406
    case serverError = 500
    case emptyParameters = 501
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidAuthorization:
            return "토큰이 만료되었습니다. 다시 로그인 해주세요."
        case .takenEmail:
            return "이미 가입된 회원입니다. 로그인 해주세요."
        case .serverError:
            return "서버 에러입니다. 잠시 후 이용해주세요."
        case .emptyParameters:
            return "request header/body를 확인해주세요."
        }
    }
}
