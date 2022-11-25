//
//  Date+Extension.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/11.
//

import Foundation

extension Date {
    func toBirthString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter.string(from: self)
    }
    
    func toChatString() -> String {
        let dateFormatter = DateFormatter()
        
        let current = Calendar.current
        if current.isDateInToday(Date()) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: self)
        } else {
            dateFormatter.dateFormat = "M/dd HH:mm"
            return dateFormatter.string(from: self)
        }
    }
}
