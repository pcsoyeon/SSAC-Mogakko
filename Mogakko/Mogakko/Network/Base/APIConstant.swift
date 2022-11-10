//
//  APIConstant.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/09.
//

import Foundation

enum APIConstant {
    
}

// MARK: - Base URL

extension APIConstant {
    struct BaseURL {
        static let test = "http://api.sesac.co.kr:1207"
        static let real = ""
    }
}

// MARK: - Content-Type

extension APIConstant {
    struct ContentType {
        static let contentType = "Content-Type"
        static let json = "application/json"
        static let formUrlEncoded = "application/x-www-form-urlencoded"
    }
}

// MARK: - Id Token

extension APIConstant {
    static let idtoken = "idtoken"
}


