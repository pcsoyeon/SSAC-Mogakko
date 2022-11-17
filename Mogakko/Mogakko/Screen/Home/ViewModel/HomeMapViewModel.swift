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
    
    var isLocationEnable = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Network
    
    func requestSearch(request: SearchRequest, completionHandler: @escaping (SearchResponse?, APIError?) -> Void) {
        GenericAPI.shared.requestDecodableData(type: SearchResponse.self, router: QueueRouter.search(request: request)) { response in
            switch response {
            case .success(let data):
                completionHandler(data, nil)
                
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
}
