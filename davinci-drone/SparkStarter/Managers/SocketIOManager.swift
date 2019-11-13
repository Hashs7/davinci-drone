//
//  SocketManager.swift
//  davinci-drone
//
//  Created by Sébastien Hernoux on 13/11/2019.
//  Copyright © 2019 Sébastien Hernoux. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager {
    struct Ctx {
        var ip: String
        var port: String
        var modeVerbose: Bool
        
        func fullIp() -> String {
            return "http://\(ip):\(port)"
        }
        static func debugContext() -> Ctx {
            return Ctx(ip: "192.168.1.40", port: "3000", modeVerbose: false)
        }
    }
    
    static let instance = SocketIOManager()
    var manager: SocketManager? = nil
    var socket: SocketIOClient? = nil
    
    func setup(ctx: Ctx = Ctx.debugContext()) {
        manager = SocketManager(socketURL: URL(string: ctx.fullIp())!, config: [.log(ctx.modeVerbose), .compress])
        socket = manager?.defaultSocket
    }
    
    func connect(callback: @escaping (String)->()) {
        if manager == nil {
            setup()
        }
        listenToConnection(callback: callback)
        socket?.connect()
    }
    
    func disconnect() {
        socket?.disconnect()
    }
    
    func listenToConnection(callback: @escaping (String)->()) {
        socket?.on(clientEvent: .connect) {data, ack in
            print("Socket CONNECTED")
            callback("connected")
        }
        
        socket?.on(clientEvent: .disconnect) {data, ack in
            print("Socket Disconnect")
            callback("disconnect")
        }
    }
    
    func listenToChannel(channel: String, callback: @escaping (String?)->()) {
        socket?.on(channel) {data, ack in
            print()
            if let d = data.first,
               let dataStr = d as? String {
                callback(dataStr)
            } else {
                callback(nil)
            }
            ack.with("Got it", "cc")
        }
    }
    
    func emitValue(_ value: String, toChannel channel: SocketChannels) {
        socket?.emit(channel.rawValue, value)
    }
}


enum SocketChannels: String {
    case detectSymbol
}
