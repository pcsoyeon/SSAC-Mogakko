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
    case studyRequest(uid: String)
    case studyAccept(uid: String)
    case dodge(uid: String)
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
        case .studyRequest:
            return Endpoint.Queue.studyRequest
        case .studyAccept:
            return Endpoint.Queue.studyAccept
        case .dodge:
            return Endpoint.Queue.dodge
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .queue, .deleteQueue, .search, .myQueueState, .studyRequest, .studyAccept, .dodge:
            return [APIConstant.ContentType.contentType : APIConstant.ContentType.formUrlEncoded,
                    APIConstant.idtoken : UserData.idtoken]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .queue, .search, .studyRequest, .studyAccept, .dodge:
            return .post
        case .deleteQueue:
            return .delete
        case .myQueueState:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .queue(let request):
            return ["long" : "\(request.long)",
                    "lat" : "\(request.lat)",
                    "studylist" : request.studyList ]
        case .deleteQueue:
            return ["" : ""]
        case .search(let request):
            return ["lat" : "\(request.lat)",
                    "long" : "\(request.long)"]
        case .myQueueState:
            return ["" : ""]
        case .studyRequest(let uid), .studyAccept(let uid), .dodge(let uid):
            return ["otheruid" : "\(uid)"]
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .queue:
            return URLEncoding(arrayEncoding: .noBrackets)
        case .deleteQueue, .search, .myQueueState, .studyRequest, .studyAccept:
            return URLEncoding.default
        case .dodge:
            return JSONEncoding.default
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        var request = URLRequest(url: url)
        request.method = method
        request.headers = HTTPHeaders(headers)
        
        switch self {
        case .queue, .deleteQueue, .search, .myQueueState, .studyRequest, .studyAccept, .dodge:
            if let parameters = parameters {
                request = try encoding.encode(request, with: parameters)
            }
        }
        return request
    }
}
