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
        
        let request = SignupRequest(phoneNumber: UserDefaults.standard.string(forKey: Constant.UserDefaults.phoneNumber)!,
                                    FCMtoken: UserDefaults.standard.string(forKey: Constant.UserDefaults.FCMtoken)!,
                                    nick: UserDefaults.standard.string(forKey: Constant.UserDefaults.nick)!,
                                    birth: UserDefaults.standard.string(forKey: Constant.UserDefaults.birth)!,
                                    email: UserDefaults.standard.string(forKey: Constant.UserDefaults.email)!,
                                    gender: UserDefaults.standard.integer(forKey: Constant.UserDefaults.nick))
        
        UserAPI.shared.requestSignup(signup: request) { response in
            
            switch response {
            case .success(let data):
                completionHandler(data)
            case .failure(let error):
                completionHandler(error.rawValue)
            }
        }
    }
}
