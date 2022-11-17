//
//  HomeMapViewModel.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/14.
//

import Foundation
import CoreLocation
import MapKit

import RxCocoa
import RxSwift

final class HomeMapViewModel {
    
    // MARK: - Property
    
    var isLocationEnable = BehaviorRelay<Bool>(value: false)
    
    var fromQueue = BehaviorRelay<[FromQueue]>(value: [])
    var fromRequestedQueue = BehaviorRelay<[FromQueue]>(value: [])
    var recommend = BehaviorRelay<[String]>(value: [])
    
    // MARK: - Network
    
    func requestSearch(request: SearchRequest, completionHandler: @escaping (APIError?) -> Void) {
        GenericAPI.shared.requestDecodableData(type: SearchResponse.self, router: QueueRouter.search(request: request)) { [weak self] response in
            guard let self = self else { return }
            
            switch response {
            case .success(let data):
                
                print("============ ✨ 주변 새싹 정보 POST ✨ ============")
                
                self.fromQueue.accept(data.fromQueueDB)
                self.fromRequestedQueue.accept(data.fromQueueDBRequested)
                self.recommend.accept(data.fromRecommend)
                completionHandler(nil)
                
            case .failure(let error):
                completionHandler(error)
            }
        }
    }
}
