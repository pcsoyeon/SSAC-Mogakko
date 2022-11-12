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
}
