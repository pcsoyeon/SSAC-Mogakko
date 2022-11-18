//
//  UserAPI.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/10.
//

import Foundation

import Alamofire
import FirebaseAuth

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
    
    // MARK: - Signup
    
    func requestSignup(signup: SignupRequest, completionHandler: @escaping (Result<Int, APIError>)-> Void) {
        AF.request(UserRouter.signup(signupRequest: signup))
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
    
    // MARK: - Withdraw
    
    func requestWithdraw(completionHandler: @escaping (Result<Int, APIError>) -> Void) {
        AF.request(UserRouter.withdraw)
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
    
    // MARK: - Mypage
    
    func updateMypage(mypage: MypageRequest, completionHandler: @escaping (Result<Int, APIError>) -> Void) {
        AF.request(UserRouter.mypage(mypageRequest: mypage))
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
    
    // MARK: - Refresh IdToken
    
    func refreshIdToken(completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            
            if let idToken = idToken {
                UserData.idtoken = idToken
                completion(.success(idToken))
            }
            
            if let error = error {
                completion(.failure(error))
            }
        }
    }
}
