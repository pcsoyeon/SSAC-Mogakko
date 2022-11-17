//
//  GenderViewModel.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/08.
//

import Foundation

import RxCocoa
import RxSwift

final class GenderViewModel {
    
    func requestSignup(completionHandler: @escaping (Int) -> Void) {
        
        let request = SignupRequest(phoneNumber: UserData.phoneNumber,
                                    FCMtoken: UserData.FCMtoken,
                                    nick: UserData.nickName,
                                    birth: UserData.birth,
                                    email: UserData.email,
                                    gender: UserData.gender)
        
        GenericAPI.shared.requestData(router: UserRouter.signup(signupRequest: request)) { response in
            switch response {
            case .success(let data):
                completionHandler(data)
            case .failure(let error):
                completionHandler(error.rawValue)
            }
        }
        
    }
}
