//
//  WebSocketManager.swift
//  PetHood
//
//  Created by MacPro on 2024/7/24.
//

import Foundation
import Starscream

class WebSocketManager {
    
    var socket:WebSocket!
    var isConnected:Bool = false
    
    // 静态属性存储单例实例
    static let shared = WebSocketManager()
    
    private init() {
        initManager()
    }
    
    func initManager() {
        var request = URLRequest(url: URL(string: "http://localhost:8080")!)
        //设置请求头
        request.timeoutInterval = 5 // Sets the timeout for the connection
//        request.setValue("someother protocols", forHTTPHeaderField: "Sec-WebSocket-Protocol")
//        request.setValue("14", forHTTPHeaderField: "Sec-WebSocket-Version")
//        request.setValue("chat,superchat", forHTTPHeaderField: "Sec-WebSocket-Protocol")
//        request.setValue("Everything is Awesome!", forHTTPHeaderField: "My-Awesome-Header")
     
        socket = WebSocket(request: request)
        socket.delegate = self
        //是否需要回应ping
//        socket.respondToPingWithPong = false
        
        socket.onEvent = { event in
            print("socket_event:\(event)")
            
        }
        
    }
    
    func writeData(_ data:Data) {
        socket.write(data: data) {
            print("write_data:\(data)")
        }
    }
    
    func writeString(_ data:String) {
        socket.write(string: data) {
            print("write_string:\(data)")
        }
    }
    
    private func sendPing(){
        let data = Data()
        socket.write(ping: data) {
            print("write_ping:\(data)")
        }
    }
    
    func disconnectSocket() {
        socket.disconnect(closeCode: CloseCode.normal.rawValue)
    }
    
    func connectSocket() {
        
        socket.connect()
    }
    
    
    private func handleError(_ error:Error?) {
        print("handle error ==\(String(describing: error))")
    }
    
    
}

extension WebSocketManager : WebSocketDelegate {
    func didReceive(event: Starscream.WebSocketEvent, client: any Starscream.WebSocketClient) {
        print("didReceive====\(event)");
        switch event {
            case .connected(let headers):
                isConnected = true
                print("websocket is connected: \(headers)")
            case .disconnected(let reason, let code):
                isConnected = false
                print("websocket is disconnected: \(reason) with code: \(code)")
            case .text(let string):
                print("Received text: \(string)")
            case .binary(let data):
                print("Received data: \(data.count)")
            case .ping(_):
                break
            case .pong(_):
                break
            case .viabilityChanged(_):
                break
            case .reconnectSuggested(_):
                break
            case .cancelled:
                isConnected = false
            case .error(let error):
                isConnected = false
                handleError(error)
                case .peerClosed:
                       break
            }
    }
    
    
}
