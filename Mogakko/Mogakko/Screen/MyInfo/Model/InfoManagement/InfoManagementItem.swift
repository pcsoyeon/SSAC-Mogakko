//
//  InfoManagementItem.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/15.
//

import Foundation

// MARK: - InfoManagementItemType

enum InfoManagementItemType {
    case background
    case card
    case gender
    case study
    case allow
    case age
    case withdraw
}

// MARK: - InfoManagementItem

protocol InfoManagementItem {
    var type: InfoManagementItemType { get }
    var rowCount: Int { get }
}

extension InfoManagementItem {
    var rowCount: Int { return 1 }
}

// MARK: - Item

class ImageItem: InfoManagementItem {
    var type: InfoManagementItemType { return .background }
    
    var background: Int
    var sesac: Int
    
    init(background: Int, sesac: Int) {
        self.background = background
        self.sesac = sesac
    }
}

class CardItem: InfoManagementItem {
    var type: InfoManagementItemType { return .card }
    
    var nickname: String
    var reputation: [Int]
    var review: String
    
    init(nickname: String, reputation: [Int], review: String) {
        self.nickname = nickname
        self.review = review
        self.reputation = reputation
    }
}

class GenderItem: InfoManagementItem {
    var type: InfoManagementItemType { return .gender }
    
    var gender: Int
    
    init(gender: Int) {
        self.gender = gender
    }
}

class StudyItem: InfoManagementItem {
    var type: InfoManagementItemType { return .study }
    
    var study: String
    
    init(study: String) {
        self.study = study
    }
}

class AllowSearchItem: InfoManagementItem {
    var type: InfoManagementItemType { return .allow }
    
    var searchable: Int
    
    init(searchable: Int) {
        self.searchable = searchable
    }
}

class AgeItem: InfoManagementItem {
    var type: InfoManagementItemType { return .age }
    
    var ageMin: Int
    var ageMax: Int
    
    init(ageMin: Int, ageMax: Int) {
        self.ageMin = ageMin
        self.ageMax = ageMax
    }
}

class WithdrawItem: InfoManagementItem {
    var type: InfoManagementItemType { return .withdraw }
}
