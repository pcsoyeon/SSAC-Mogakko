//
//  Metric.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/07.
//

import Foundation

enum Metric {
    
}

// MARK: - Margin

extension Metric {
    static let margin: CGFloat = 16
}

// MARK: - Navigation

extension Metric {
    static let navigationHeight: CGFloat = 44
    static let navigationTitleBottom: CGFloat = 11
    
    static let navigationButtonLeading: CGFloat = 16
    static let navigationButtonTrailing: CGFloat = 16
    static let navigationButtonBottom: CGFloat = 10
    static let navigationButtonSize: CGFloat = 24
}

// MARK: - TextField

extension Metric {
    static let inputTextFieldHeight: CGFloat = 48
    
    static let messageTextFieldHeight: CGFloat = 52
    static let messageTextFieldTrailing: CGFloat = 14
    static let messageTextFieldIconSize: CGFloat = 20
}

// MARK: - Search Bar

extension Metric {
    static let searchBarHeight: CGFloat = 36
}

// MARK: - Floating Button

extension Metric {
    static let floatingButtonSize: CGFloat = 56
    static let floatingButtonRadius: CGFloat = 28
}
