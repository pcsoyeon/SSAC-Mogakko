//
//  UINavigationViewController+Extension.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/24.
//

import UIKit

extension UINavigationController {
    func pushViewControllers(_ inViewControllers: [UIViewController], animated: Bool) {
        var stack = self.viewControllers
        stack.append(contentsOf: inViewControllers)
        self.setViewControllers(stack, animated: animated)
    }
}
