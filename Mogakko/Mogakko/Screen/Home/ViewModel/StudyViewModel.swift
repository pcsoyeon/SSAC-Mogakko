//
//  StudyViewModel.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/17.
//

import Foundation

import Alamofire
import RxCocoa
import RxSwift

final class StudyViewModel {
    
    // MARK: - Property
    
    var fromRecommend = BehaviorRelay<[String]>(value: [])
    var studylist = BehaviorRelay<[String]>(value: [])
    var nearby = BehaviorRelay<[String]>(value: [])
    
    var selectedList: [String] = []
    var selectedRelay = BehaviorRelay<[String]>(value: [])
    
    var snapshotList = BehaviorRelay<[[String]]>(value: [])
    
    // MARK: - Method
    
    func requestSearch(request: SearchRequest, completionHandler: @escaping (APIError?) -> Void) {
        GenericAPI.shared.requestDecodableData(type: SearchResponse.self, router: QueueRouter.search(request: request)) { [weak self] response in
            guard let self = self else { return }
            
            switch response {
            case .success(let data):
                
                print("============ ✨ 주변 새싹 정보 POST ✨ ============")
                
                var list: [String] = []
                
                list.append(contentsOf: data.fromRecommend)
                
                for queue in data.fromQueueDB {
                    list.append(contentsOf:queue.studylist)
                }
                for queue in data.fromQueueDBRequested {
                    list.append(contentsOf: queue.studylist)
                }
                
                self.nearby.accept(self.removeDuplicate(list))
                
                completionHandler(nil)
                
            case .failure(let error):
                completionHandler(error)
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
    
    func removeDuplicate (_ array: [String]) -> [String] {
        var removedArray = [String]()
        for i in array {
            if removedArray.contains(i) == false {
                removedArray.append(i)
            }
        }
        return removedArray
    }
    
    func appendSelectedList(_ study: String) {
        selectedList.append(study)
        
        selectedRelay.accept(selectedList)
    }
    
    func removeSelectedList(_ at: Int) {
        selectedList.remove(at: at)
        selectedRelay.accept(selectedList)
    }
    
    func makeSnapshot(completionHandler: @escaping ([[String]]) -> Void) {
        
        completionHandler([nearby.value, selectedList])
    }
}
