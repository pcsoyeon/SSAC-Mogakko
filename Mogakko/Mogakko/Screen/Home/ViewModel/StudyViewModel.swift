//
//  StudyViewModel.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/17.
//

import Foundation

import RxCocoa
import RxSwift

struct Item: Hashable {
    var id: UUID
    var study: String
}

final class StudyViewModel {
    
    // MARK: - Property
    
    var nearbyRelay = BehaviorRelay<[Item]>(value: [])
    
    var wantToDoList: [Item] = []
    var wantToDoStringList: [String] = []
    var wantToDoRelay = BehaviorRelay<[Item]>(value: [])
    
    var snapshotList = BehaviorRelay<[[Item]]>(value: [])
    
    var mapLatitude = BehaviorRelay<Double>(value: 0.0)
    var mapLongitude = BehaviorRelay<Double>(value: 0.0)
    
    // MARK: - Method
    
    func requestSearch(completionHandler: @escaping (APIError?) -> Void) {
        let request = SearchRequest(lat: mapLatitude.value, long: mapLongitude.value)
        GenericAPI.shared.requestDecodableData(type: SearchResponse.self, router: QueueRouter.search(request: request)) { [weak self] response in
            guard let self = self else { return }
            
            switch response {
            case .success(let data):
                
                var itemList: [Item] = []
                
                var studyArray: [String] = []
                studyArray.append(contentsOf: data.fromRecommend)
                
                for item in data.fromQueueDB {
                    studyArray.append(contentsOf: item.studylist)
                }
                
                for item in data.fromQueueDBRequested {
                    studyArray.append(contentsOf: item.studylist)
                }
                
                studyArray = self.removeDuplicateStringArray(studyArray)
                for item in studyArray {
                    itemList.append(Item(id: UUID(), study: item))
                }
                
                self.nearbyRelay.accept(itemList)
                
                completionHandler(nil)
                
            case .failure(let error):
                completionHandler(error)
            }
        }
    }
    
    func requestQueue(completionHandler: @escaping (Int) -> Void) {
        var request = QueueRequest(lat: 0.0, long: 0.0, studyList: [])
        if wantToDoRelay.value.isEmpty {
            request = QueueRequest(lat: mapLatitude.value, long: mapLongitude.value, studyList: ["anything"])
        } else {
            var studylist: [String] = []
            for item in wantToDoRelay.value {
                studylist.append(item.study)
            }
            
            request = QueueRequest(lat: mapLatitude.value, long: mapLongitude.value, studyList: studylist)
        }
        
        QueueAPI.shared.requestQueue(request: request) { statusCode in
            completionHandler(statusCode)
        }
    }
    
    func removeDuplicateStringArray(_ array: [String]) -> [String] {
        var removedArray = [String]()
        for item in array {
            if removedArray.contains(item) == false  {
                removedArray.append(item)
            }
        }
        return removedArray
    }
    
    func appendWantToDoList(_ study: String, completionHandler: @escaping (Bool) -> Void) {
        for item in wantToDoList {
            wantToDoStringList.append(item.study)
        }
        
        if wantToDoStringList.contains(study) == false {
            wantToDoList.append(Item(id: UUID(), study: study))
            completionHandler(true)
        } else {
            completionHandler(false)
        }
        
        wantToDoRelay.accept(wantToDoList)
    }
    
    func removeSelectedList(_ at: Int) {
        wantToDoStringList = []
        for item in wantToDoRelay.value {
            wantToDoStringList.append(item.study)
        }
        
        wantToDoList.remove(at: at)
        wantToDoStringList.remove(at: at)
        wantToDoRelay.accept(wantToDoList)
    }
    
    func makeSnapshot(completionHandler: @escaping ([[Item]]) -> Void) {
        completionHandler([nearbyRelay.value, wantToDoList])
    }
}
