//
//  SocketIOManager.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/25.
//

import Foundation

import SocketIO

final class SocketIOManager {
    
    static let shared = SocketIOManager()
    
    var manager: SocketManager!
    
    // 이벤트를 전달받기 위한 소켓
    var socket: SocketIOClient!
    
    private init() {
        manager = SocketManager(socketURL: URL(string: APIConstant.BaseURL.test)!,
                                config: [
//                                    .log(true),
                                    .compress,
//                                    .forceWebsockets(true)
                                ])
        
        socket = manager.defaultSocket // room - 1:1로 채팅하는 경우에는 따로 지정을 해야한다.
        
        // 연결
        socket.on(clientEvent: .connect) { data, ack in
            print("😇 SOCKET IS CONNECTED", data, ack)
        }
        
        // 연결 해제
        socket.on(clientEvent: .disconnect) { data, ack in
            print("🤮 SOCKET IS DISCONNECTED", data, ack)
        }

        // 이벤트 수신
        socket.on("sesac") { dataArray, ack in
            print("😇 SESAC RECEIVED", dataArray, ack)
            
            let data = dataArray[0] as! NSDictionary
            let id = data["_id"] as! String
            let chat = data["chat"] as! String
            let createdAt = data["createdAt"] as! String
            let from = data["from"] as! String
            let to = data["to"] as! String
            
            NotificationCenter.default.post(name: NSNotification.Name("getMessage"), object: self, userInfo: [
                "_id" : id,
                "chat" : chat,
                "createdAt" : createdAt,
                "from" : from,
                "to" : to
            ])
        }
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}
