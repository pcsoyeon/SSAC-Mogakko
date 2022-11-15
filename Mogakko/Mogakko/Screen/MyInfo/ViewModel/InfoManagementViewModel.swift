//
//  InfoManagementViewModel.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/13.
//

import Foundation

import FirebaseAuth
import RxCocoa
import RxSwift

final class InfoManagementViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func getUserInfo(completionHandler: @escaping (Login?) -> Void) {
        GenericAPI.shared.requestDecodableData(type: Login.self, router: UserRouter.login) { response in
            switch response {
            case .success(let data):
                print("🍀 사용자 정보 \(data)")
                
                UserDefaults.standard.set(data.nick, forKey: Constant.UserDefaults.nick)
                
                completionHandler(data)
                
            case .failure(let error):
                switch error {
                case .takenUser, .invalidNickname:
                    return
                case .invalidAuthorization:
                    Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                        
                        if let error = error {
                            print(error)
                            return
                        }
                        
                        if let idToken = idToken {
                            UserDefaults.standard.set(idToken, forKey: Constant.UserDefaults.idtoken)
                            print("✨ 새로 발급 받은 토큰 - \(idToken)")
                        }
                    }
                case .unsubscribedUser:
                    print("미가입회원")
                case .serverError:
                    print("서버오류")
                case .emptyParameters:
                    print("클라이언트오류")
                }
                
            }
        }
    }
    
    private func updateMypage() {
        
    }
}
