//
//  UserDefaults.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/11.
//

import Foundation

// MARK: - UserDefaults

@propertyWrapper
struct UserDefault<T> {
    private let key: String
    private let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

// MARK: - UserData

struct UserData {
    @UserDefault(key: UserDefaultsKeyEnum.isNotFirst.rawValue, defaultValue: true)
    static var isNotFirst: Bool
    
    @UserDefault(key: UserDefaultsKeyEnum.idtoken.rawValue, defaultValue: "")
    static var idtoken: String
    
    @UserDefault(key: UserDefaultsKeyEnum.phoneNumber.rawValue, defaultValue: "")
    static var phoneNumber: String
    
    @UserDefault(key: UserDefaultsKeyEnum.FCMtoken.rawValue, defaultValue: "")
    static var FCMtoken: String
    
    @UserDefault(key: UserDefaultsKeyEnum.nickName.rawValue, defaultValue: "")
    static var nickName: String
    
    @UserDefault(key: UserDefaultsKeyEnum.birth.rawValue, defaultValue: "")
    static var birth: String
    
    @UserDefault(key: UserDefaultsKeyEnum.email.rawValue, defaultValue: "")
    static var email: String
    
    @UserDefault(key: UserDefaultsKeyEnum.gender.rawValue, defaultValue: 0)
    static var gender: Int
}

enum UserDefaultsKeyEnum: String {
    case isNotFirst = "isNotFirst"
    case idtoken = "idtoken"
    case phoneNumber = "phoneNumber"
    case FCMtoken = "FCMtoken"
    case nickName = "nickName"
    case birth = "birth"
    case email = "email"
    case gender = "gender"
}
