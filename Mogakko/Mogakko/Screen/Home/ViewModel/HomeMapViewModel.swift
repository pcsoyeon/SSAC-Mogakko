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
    
    // MARK: - Rx Property
    
    var isLocationEnable = BehaviorRelay<Bool>(value: false)
    
    var fromQueue = BehaviorRelay<[FromQueue]>(value: [])
    var fromRequestedQueue = BehaviorRelay<[FromQueue]>(value: [])
    var recommend = BehaviorRelay<[String]>(value: [])
    
    var totalQueue = BehaviorRelay<[FromQueue]>(value: [])
    var manQueue = BehaviorRelay<[FromQueue]>(value: [])
    var womanQueue = BehaviorRelay<[FromQueue]>(value: [])
    
    var pressedButtonType = BehaviorRelay<MDSFilterType>(value: .total)
    
    // MARK: - Property
    
    private var manList: [FromQueue] = []
    private var womanList: [FromQueue] = []
    
    // MARK: - Network
    
    func requestSearch(request: SearchRequest, completionHandler: @escaping (APIError?) -> Void) {
        GenericAPI.shared.requestDecodableData(type: SearchResponse.self, router: QueueRouter.search(request: request)) { [weak self] response in
            guard let self = self else { return }
            
            switch response {
            case .success(let data):
                
                self.fromQueue.accept(data.fromQueueDB + data.fromQueueDBRequested)
//                self.fromRequestedQueue.accept(data.fromQueueDBRequested)
                self.recommend.accept(data.fromRecommend)
                
                self.filterQueueByGender(data.fromQueueDB, data.fromQueueDBRequested)
                
                completionHandler(nil)
                
            case .failure(let error):
                completionHandler(error)
            }
        }
    }
    
    private func filterQueueByGender(_ queue: [FromQueue], _ requestedQueue: [FromQueue]) {
        for item in queue {
            switch item.gender {
            case 0:
                self.womanList.append(item)
            case 1:
                self.manList.append(item)
            default:
                return
            }
        }
        
        for item in requestedQueue {
            switch item.gender {
            case 0:
                self.womanList.append(item)
            case 1:
                self.manList.append(item)
            default:
                return
            }
        }
        
        womanQueue.accept(womanList)
        manQueue.accept(manList)
    }
    
    func requestMyState(completionHandler: @escaping (MyStateResponse?, APIError?) -> Void) {
        GenericAPI.shared.requestDecodableData(type: MyStateResponse.self, router: QueueRouter.myQueueState) { response in
            switch response {
            case .success(let data):
                print("============ ✨ 내 상태 GET ✨ ============")
                completionHandler(data, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
}
