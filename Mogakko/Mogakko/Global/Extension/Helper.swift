//
//  Helper.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/12.
//

import UIKit

class Helper {
    static func convertNavigationRootViewController(view: UIView, controller: UIViewController) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let navi = UINavigationController(rootViewController: controller)
            view.window?.rootViewController = navi
            UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
            view.window?.makeKeyAndVisible()
        }
    }
    
    static func convertRootViewController(view: UIView, controller: UIViewController) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            view.window?.rootViewController = controller
            UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
            view.window?.makeKeyAndVisible()
        }
    }
}
