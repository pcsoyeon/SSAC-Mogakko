//
//  ChatRouter.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/25.
//

import Foundation

import Alamofire

enum ChatRouter {
    case chat(to: String, chat: String)
    case lastchatDate(from: String, date: String)
}

extension ChatRouter: URLRequestConvertible {
    var baseURL: URL {
        return URL(string: APIConstant.BaseURL.test)!
    }
    
    var path: String {
        switch self {
        case .chat(let to, _):
            return Endpoint.Chat.chat + "/\(to)"
        case .lastchatDate(let from, _):
            return Endpoint.Chat.lastchatDate + "/\(from)"
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .chat:
            return [APIConstant.ContentType.contentType : APIConstant.ContentType.formUrlEncoded,
                    APIConstant.idtoken : UserData.idtoken]
        case .lastchatDate:
            return [APIConstant.ContentType.contentType : APIConstant.ContentType.json,
                    APIConstant.idtoken : UserData.idtoken]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .chat:
            return .post
        case .lastchatDate:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .chat(_, let chat):
            return ["chat" : "\(chat)"]
        case .lastchatDate(_, let date):
            return ["lastchatDate" : "\(date)"]
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .chat:
            return JSONEncoding.default
        case .lastchatDate:
            return URLEncoding.queryString
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        var request = URLRequest(url: url)
        request.method = method
        request.headers = HTTPHeaders(headers)
        
        switch self {
        case .chat, .lastchatDate:
            if let parameters = parameters {
                request = try encoding.encode(request, with: parameters)
            }
        }
        return request
    }
}
