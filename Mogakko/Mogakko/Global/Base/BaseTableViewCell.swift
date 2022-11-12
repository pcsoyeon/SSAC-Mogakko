//
//  BaseTableViewCell.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/07.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureAttribute()
        configureHierarchy()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureAttribute() {}
    func configureHierarchy() {}
}
