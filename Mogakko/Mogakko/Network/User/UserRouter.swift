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
    case refresh(idToken: String)
    case signup(signupRequest: SignupRequest)
    case withdraw
    case updateFcmToken
    case mypage(mypageRequest: MypageRequest)
}

extension UserRouter: URLRequestConvertible {
    var baseURL: URL {
        return URL(string: APIConstant.BaseURL.test)!
    }
    
    var path: String {
        switch self {
        case .login, .signup, .refresh:
            return Endpoint.User.user
        case .withdraw:
            return Endpoint.User.withDraw
        case .updateFcmToken:
            return Endpoint.User.updateFcmToken
        case .mypage:
            return Endpoint.User.mypage
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .login:
            return [APIConstant.ContentType.contentType : APIConstant.ContentType.json,
                    APIConstant.idtoken : UserData.idtoken ]
        case .refresh(let idToken):
            return [APIConstant.ContentType.contentType : APIConstant.ContentType.json,
                    APIConstant.idtoken : idToken]
        case .signup, .withdraw, .updateFcmToken, .mypage:
            return [APIConstant.ContentType.contentType : APIConstant.ContentType.formUrlEncoded,
                    APIConstant.idtoken : UserData.idtoken]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .refresh:
            return .get
        case .signup:
            return .post
        case .withdraw:
            return .post
        case .updateFcmToken, .mypage:
            return .put
        }
    }
    
    var parameters: [String: String] {
        switch self {
        case .login, .refresh:
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
        case .mypage(let mypageRequest):
            return ["searchable" : "\(mypageRequest.searchable)",
                    "ageMin" : "\(mypageRequest.ageMin)",
                    "ageMax" : "\(mypageRequest.ageMax)",
                    "gender" : "\(mypageRequest.gender)",
                    "study" : mypageRequest.study]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        var request = URLRequest(url: url)
        request.method = method
        request.headers = HTTPHeaders(headers)
        
        switch self {
        case .login, .signup, .withdraw, .updateFcmToken, .mypage, .refresh:
            request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        }
        
        return request
    }
}
