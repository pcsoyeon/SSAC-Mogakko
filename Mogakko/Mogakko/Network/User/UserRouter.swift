//
//  UserRouter.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/10.
//

import Foundation

import Alamofire

enum UserRouter {
    case login
    case signup(signupRequest: SignupRequest)
    case withdraw
    case updateFcmToken
}

extension UserRouter: URLRequestConvertible {
    var baseURL: URL {
        return URL(string: APIConstant.BaseURL.test)!
    }
    
    var path: String {
        switch self {
        case .login, .signup:
            return Endpoint.User.user
        case .withdraw:
            return Endpoint.User.withDraw
        case .updateFcmToken:
            return Endpoint.User.updateFcmToken
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .login:
            return [APIConstant.ContentType.contentType : APIConstant.ContentType.json,
                    APIConstant.idtoken : UserDefaults.standard.string(forKey: "idtoken")! ]
        case .signup, .withdraw, .updateFcmToken:
            return [APIConstant.ContentType.contentType : APIConstant.ContentType.formUrlEncoded,
                    APIConstant.idtoken : UserDefaults.standard.string(forKey: "idtoken")!]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .get
        case .signup:
            return .post
        case .withdraw:
            return .post
        case .updateFcmToken:
            return .put
        }
    }
    
    var parameters: [String: String] {
        switch self {
        case .login:
            return ["" : ""]
        case .signup(let signupRequest):
            return ["phoneNumber" : signupRequest.phoneNumber,
                    "FCMtoken" : signupRequest.FCMtoken,
                    "nick" : signupRequest.nick,
                    "birth" : signupRequest.birth,
                    "email" : signupRequest.email,
                    "gender" : "\(signupRequest.gender)"]
        case .withdraw:
            return ["" : ""]
        case .updateFcmToken:
            return ["" : ""]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        var request = URLRequest(url: url)
        request.method = method
        request.headers = HTTPHeaders(headers)
        
        switch self {
        case .login, .signup, .withdraw, .updateFcmToken:
            request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        }
        
        return request
    }
}
