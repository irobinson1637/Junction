//
//  SocketIOManager.swift
//  socketTest
//
//  Created by Isaac Robinson on 8/15/16.
//  Copyright © 2016 Isaac Robinson. All rights reserved.
//

import UIKit

class SocketIOManager: NSObject {
        static let sharedInstance = SocketIOManager()
    
    override init() {
        super.init()
    }
    
    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "localhost:3080")!)
    
    func establishConnection() {
        socket.connect()
        socket.emit("iam:joe")
    }
    
    
    func closeConnection() {
        socket.disconnect()
    }

   

}
