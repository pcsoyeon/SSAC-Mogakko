//
//  NetworkMonitor.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/09.
//

import UIKit
import Network

extension UIViewController {
    func networkMoniter() {
        let monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = {
            path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    return
                }
            } else {
                DispatchQueue.main.async {
                    self.showToast(message: "네트워크 연결이 원활하지 않습니다.")
                }
            }
        }
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
    }
}
