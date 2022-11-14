//
//  GenericAPI.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/14.
//

import Foundation

import Alamofire

final class GenericAPI {
    static let shared = GenericAPI()
    
    private init() { }
    
    // MARK: - Decodable
    
    func requestDecodableData<T: Decodable>(type: T.Type = T.self, router: URLRequestConvertible, completionHandler: @escaping (Result<T, APIError>) -> Void) {
        AF.request(router)
            .validate(statusCode: 200...500)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    completionHandler(.success(data))
                    
                case .failure(_):
                    guard let statusCode = response.response?.statusCode else { return }
                    guard let error = APIError(rawValue: statusCode) else { return }
                    
                    completionHandler(.failure(error))
                }
            }
    }
    
    // MARK: - Data
    
    func requestData(router: URLRequestConvertible, completionHandler: @escaping (Result<Int, APIError>) -> Void) {
        AF.request(router)
            .validate(statusCode: 200...500)
            .responseData { response in
                switch response.result {
                    
                case .success(_):
                    completionHandler(.success(200))
                    
                case .failure(_):
                    guard let statusCode = response.response?.statusCode else { return }
                    guard let error = APIError(rawValue: statusCode) else { return }
                    
                    completionHandler(.failure(error))
                }
            }
    }
}
