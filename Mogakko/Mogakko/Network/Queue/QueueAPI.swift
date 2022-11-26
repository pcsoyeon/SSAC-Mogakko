//
//  QueueAPI.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/21.
//

import Foundation

import Alamofire
import FirebaseAuth

final class QueueAPI {
    static let shared = QueueAPI()
    
    private init() { }
    
    func requestMyQueue(completionHandler: @escaping (MyStateResponse?, Int?) -> Void) {
        AF.request(QueueRouter.myQueueState)
            .validate(statusCode: 200...500)
            .responseDecodable(of: MyStateResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completionHandler(data, nil)
                    
                case .failure(_):
                    guard let statusCode = response.response?.statusCode else { return }
                    completionHandler(nil, statusCode)
                }
            }
    }
    
    func requestQueue(request: QueueRequest, completionHandler: @escaping (Int) -> Void) {
        AF.request(QueueRouter.queue(request: request))
            .validate(statusCode: 200...500)
            .responseData { response in
                switch response.result {
                    
                case .success(_):
                    guard let statusCode = response.response?.statusCode else { return }
                    completionHandler(statusCode)
                    
                case .failure(_):
                    guard let statusCode = response.response?.statusCode else { return }
                    completionHandler(statusCode)
                }
            }
    }
    
    func deleteQueue(completionHandler: @escaping (Int) -> Void) {
        AF.request(QueueRouter.deleteQueue)
            .validate(statusCode: 200...500)
            .responseData { response in
                switch response.result {
                    
                case .success(_):
                    guard let statusCode = response.response?.statusCode else { return }
                    completionHandler(statusCode)
                    
                case .failure(_):
                    guard let statusCode = response.response?.statusCode else { return }
                    completionHandler(statusCode)
                }
            }
    }
    
    func requestStudy(uid: String, completionHandler: @escaping (Int) -> Void) {
        AF.request(QueueRouter.studyRequest(uid: uid))
            .validate(statusCode: 200...500)
            .responseData { response in
                switch response.result {
                    
                case .success(_):
                    guard let statusCode = response.response?.statusCode else { return }
                    completionHandler(statusCode)
                    
                case .failure(_):
                    guard let statusCode = response.response?.statusCode else { return }
                    completionHandler(statusCode)
                }
            }
    }
    
    func requestAccept(uid: String, completionHandler: @escaping (Int) -> Void) {
        AF.request(QueueRouter.studyAccept(uid: uid))
            .validate(statusCode: 200...500)
            .responseData { response in
                switch response.result {
                    
                case .success(_):
                    guard let statusCode = response.response?.statusCode else { return }
                    completionHandler(statusCode)
                    
                case .failure(_):
                    guard let statusCode = response.response?.statusCode else { return }
                    completionHandler(statusCode)
                }
            }
    }
    
    func requestDodge(uid: String, completionHandler: @escaping (Int) -> Void) {
        AF.request(QueueRouter.dodge(uid: uid))
            .validate(statusCode: 200...500)
            .responseData { response in
                switch response.result {
                    
                case .success(_):
                    guard let statusCode = response.response?.statusCode else { return }
                    completionHandler(statusCode)
                    
                case .failure(_):
                    guard let statusCode = response.response?.statusCode else { return }
                    completionHandler(statusCode)
                }
            }
    }
}
