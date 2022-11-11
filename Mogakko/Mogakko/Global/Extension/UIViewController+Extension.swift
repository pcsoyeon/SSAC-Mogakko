//
//  UIViewController+Extension.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/08.
//

import UIKit

extension UIViewController {
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150,
                                               y: 100,
                                               width: 300,
                                               height: 40))
        
        toastLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
        toastLabel.textColor = UIColor.white
        toastLabel.font = MDSFont.Title4_R14.font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 8
        toastLabel.clipsToBounds = true
        
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 2.5,
                       delay: 0.5,
                       options: .curveEaseInOut,
                       animations: { toastLabel.alpha = 0.0 },
                       completion: {(isCompleted) in toastLabel.removeFromSuperview() })
    }
}
