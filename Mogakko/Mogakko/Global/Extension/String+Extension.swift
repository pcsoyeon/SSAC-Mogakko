//
//  String+Extension.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/08.
//

import Foundation

extension String {
    func changeToPhoneNumberPattern(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        pureNumber = pureNumber.count > 11 ? String(pureNumber[...pureNumber.index(startIndex,offsetBy: 10)]) : pureNumber
        
        for index in 0..<pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        
        return pureNumber
    }
}
