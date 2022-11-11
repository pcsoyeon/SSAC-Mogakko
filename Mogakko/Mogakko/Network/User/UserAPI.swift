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
    
    func requestLogin(completionHandler: @escaping (Login?, Int?, Error?)-> Void) {
        AF.request(UserRouter.login)
            .validate(statusCode: 200...500)
            .responseData { dataReponse in
                guard let statusCode = dataReponse.response?.statusCode else { return }
                
                switch dataReponse.result {
                    
                case .success(let data):
                    
                    let decoder = JSONDecoder()
                    guard let decodedData = try? decoder.decode(Login.self, from: data) else {
                        completionHandler(nil, statusCode, nil)
                        return
                    }
                    
                    completionHandler(decodedData, statusCode, nil)
                    
                case .failure(let error):
                    
                    completionHandler(nil, statusCode, error)
                }
            }
    }
    
    // MARK: - Signup
    
    func requestSignup(signup: SignupRequest, completionHandler: @escaping (Int?, Error?)-> Void) {
        AF.request(UserRouter.signup(signupRequest: signup))
            .validate(statusCode: 200...500)
            .responseData { dataReponse in
                guard let statusCode = dataReponse.response?.statusCode else { return }
                
                switch dataReponse.result {
                case .success(_):
                    completionHandler(statusCode, nil)
                    
                case .failure(let error):
                    completionHandler(statusCode, error)
                }
            }
    }
    
    // MARK: - Withdraw
    
    func requestWithdraw(completionHandler: @escaping (Int?, Error?) -> Void) {
        AF.request(UserRouter.withdraw)
            .validate(statusCode: 200...500)
            .responseData { dataReponse in
                guard let statusCode = dataReponse.response?.statusCode else { return }
                
                switch dataReponse.result {
                    
                case .success(_):
                    completionHandler(statusCode, nil)
                    
                case .failure(let error):
                    completionHandler(statusCode, error)
                }
            }
    }
}
