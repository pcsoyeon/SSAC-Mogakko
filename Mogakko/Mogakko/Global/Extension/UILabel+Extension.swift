//
//  UILabel+Extension.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/12.
//

import UIKit

extension UILabel {
    func setHighlighted(_ text: String, with quote: String) {
        let attributedText = NSMutableAttributedString(string: text)
        let range = NSString(string: text).range(of: quote, options: .caseInsensitive)
        let highlightColor = UIColor.green
        let highlightedAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: highlightColor]
        
        attributedText.addAttributes(highlightedAttributes, range: range)
        self.attributedText = attributedText
    }
    
    func countCurrentLines() -> Int {
        guard let text = self.text as NSString? else { return 0 }
        guard let font = self.font              else { return 0 }
        
        var attributes = [NSAttributedString.Key: Any]()
        
        if let kernAttribute = self.attributedText?.attributes(at: 0, effectiveRange: nil).first(where: { key, _ in
            return key == .kern
        }) {
            attributes[.kern] = kernAttribute.value
        }
        attributes[.font] = font
        
        let labelTextSize = text.boundingRect(
            with: CGSize(width: self.bounds.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
        )
        
        return Int(ceil(labelTextSize.height / font.lineHeight))
    }
}
