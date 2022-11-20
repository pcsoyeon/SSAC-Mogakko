//
//  SearchSesacViewModel.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/19.
//

import Foundation

import Alamofire
import RxCocoa
import RxSwift

final class SearchSesacViewModel {
    
    // MARK: - Property
    
    var fromQueue = BehaviorRelay<[FromQueue]>(value: [])
    var fromRequestedQueue = BehaviorRelay<[FromQueue]>(value: [])
    
    // MARK: - Method
    
    func requestSearch(request: SearchRequest, completionHandler: @escaping (APIError?) -> Void) {
        GenericAPI.shared.requestDecodableData(type: SearchResponse.self, router: QueueRouter.search(request: request)) { [weak self] response in
            guard let self = self else { return }
            
            switch response {
            case .success(let data):
                self.fromQueue.accept(data.fromQueueDB)
                self.fromRequestedQueue.accept(data.fromQueueDBRequested)
                
                completionHandler(nil)
                
            case .failure(let error):
                completionHandler(error)
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
}
