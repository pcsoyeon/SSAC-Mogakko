//
//  UserAPI.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/10.
//

import Foundation

import Alamofire

final class UserAPI {
    static let shared = UserAPI()
    
    private init() { }
    
    // MARK: - Login
    
    func requestLogin<T: Decodable>(type: T.Type = T.self, completionHandler: @escaping (Result<T, APIError>) -> Void) {
        AF.request(UserRouter.login)
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
    
//    func requestLogin(completionHandler: @escaping (Login?, Int?, APIError?)-> Void) {
//        AF.request(UserRouter.login)
//            .validate(statusCode: 200...500)
//            .responseData { response in
//                guard let statusCode = response.response?.statusCode else { return }
//
//                switch response.result {
//
//                case .success(let data):
//
//                    let decoder = JSONDecoder()
//                    guard let decodedData = try? decoder.decode(Login.self, from: data) else {
//                        completionHandler(nil, statusCode, nil)
//                        return
//                    }
//                    completionHandler(decodedData, statusCode, nil)
//
//                case .failure(_):
//                    guard let statusCode = response.response?.statusCode else { return }
//                    guard let error = APIError(rawValue: statusCode) else { return }
//
//                    completionHandler(nil, statusCode, error)
//                }
//            }
//    }
    
    // MARK: - Signup
    
    func requestSignup(signup: SignupRequest, completionHandler: @escaping (Int?, Error?)-> Void) {
        AF.request(UserRouter.signup(signupRequest: signup))
            .validate(statusCode: 200...500)
            .responseData { response in
                guard let statusCode = response.response?.statusCode else { return }
                
                switch response.result {
                case .success(_):
                    completionHandler(statusCode, nil)
                    
                case .failure(_):
                    guard let statusCode = response.response?.statusCode else { return }
                    guard let error = APIError(rawValue: statusCode) else { return }
                    
                    completionHandler(statusCode, error)
                }
            }
    }
    
    // MARK: - Withdraw
    
    func requestWithdraw(completionHandler: @escaping (Int?, Error?) -> Void) {
        AF.request(UserRouter.withdraw)
            .validate(statusCode: 200...500)
            .responseData { response in
                guard let statusCode = response.response?.statusCode else { return }
                
                switch response.result {
                    
                case .success(_):
                    completionHandler(statusCode, nil)
                    
                case .failure(_):
                    guard let statusCode = response.response?.statusCode else { return }
                    guard let error = APIError(rawValue: statusCode) else { return }
                    
                    completionHandler(statusCode, error)
                }
            }
    }
    
    // MARK: - Mypage
    
    func requestMypage(mypage: MypageRequest, completionHandler: @escaping (Int?, Error?) -> Void) {
        AF.request(UserRouter.mypage(mypageRequest: mypage))
            .validate(statusCode: 200...500)
            .responseData { response in
                guard let statusCode = response.response?.statusCode else { return }
                
                switch response.result {
                    
                case .success(_):
                    completionHandler(statusCode, nil)
                    
                case .failure(_):
                    guard let statusCode = response.response?.statusCode else { return }
                    guard let error = APIError(rawValue: statusCode) else { return }
                    
                    completionHandler(statusCode, error)
                }
            }
    }
}
