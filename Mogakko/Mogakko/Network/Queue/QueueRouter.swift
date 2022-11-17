//
//  QueueRouter.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/17.
//

import Foundation

import Alamofire

enum QueueRouter {
    case queue(request: QueueRequest)
    case deleteQueue
    case search(request: SearchRequest)
    case myQueueState
}

extension QueueRouter: URLRequestConvertible {
    var baseURL: URL {
        return URL(string: APIConstant.BaseURL.test)!
    }
    
    var path: String {
        switch self {
        case .queue, .deleteQueue:
            return Endpoint.Queue.queue
        case .search:
            return Endpoint.Queue.search
        case .myQueueState:
            return Endpoint.Queue.myQueueState
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .queue, .deleteQueue, .search, .myQueueState:
            return [APIConstant.ContentType.contentType : APIConstant.ContentType.formUrlEncoded,
                    APIConstant.idtoken : APIKey.idToken]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .queue, .search:
            return .post
        case .deleteQueue:
            return .delete
        case .myQueueState:
            return .get
        }
    }
    
    var parameters: [String: String] {
        switch self {
        case .queue(let request):
            return ["long" : "\(request.long)",
                    "lat" : "\(request.lat)",
                    "studyList" : "\(request.studyList)"]
        case .deleteQueue:
            return ["" : ""]
        case .search(let request):
            return ["lat" : "\(request.lat)",
                    "long" : "\(request.long)"]
        case .myQueueState:
            return ["" : ""]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        var request = URLRequest(url: url)
        request.method = method
        request.headers = HTTPHeaders(headers)
        
        switch self {
        case .queue, .deleteQueue, .search, .myQueueState:
            request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        }
        
        return request
    }
}
