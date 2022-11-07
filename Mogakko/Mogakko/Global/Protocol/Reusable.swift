//
//  Reusable.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/07.
//

import UIKit

public protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension UIViewController: Reusable {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: Reusable {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}
