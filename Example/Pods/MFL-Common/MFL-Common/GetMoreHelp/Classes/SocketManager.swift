//
//  SocketManager.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 19/05/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import SocketIO

fileprivate let url_path = "/rtc"

fileprivate let primus_ping = "primus::ping::"
fileprivate let primus_pong = "primus::pong::"
 
fileprivate let waitToReconnect = TimeInterval(5) // 5 second

// Error Codes
fileprivate let error_unauthorized = 401

public protocol HasSocketManager {
    var socketManager : SocketManager! { get }
}

fileprivate enum SocketMessageType {
    case ping(String)
    case other(String, MFLJson?)
}

protocol SocketManagerObserver: class {
    func socketManagerDidConnect(_ sender: SocketManager)
    func socketManager(_ sender: SocketManager, didDisconnectWith error: NSError?)
    func socketManager(_ sender: SocketManager, didReceive event: String, with data: MFLJson?)
}

public class SocketManager: NSObject {
    
    fileprivate let _observers = NSHashTable<AnyObject>.weakObjects()
    fileprivate var _socket : WebSocket?
    fileprivate var _attemptReconnect = true
    fileprivate let _baseUrl : String
    
    typealias PendingMessage = (message: String, completion: ((String?)->Void)?)
    fileprivate var _pendingMessages = [PendingMessage]()
    
    override init() {
        _baseUrl = ""
    
        super.init()
        assertionFailure("Base url required. Please user the init(baseURLString: String) initializer")
    }
    
    public init(baseURL: URL) {
        _baseUrl = baseURL.absoluteString
        
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterBackground), name: .UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterForground), name: .UIApplicationDidBecomeActive, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func connect(attemptReconnect: Bool = true) {
        _attemptReconnect = attemptReconnect
        _socket = _buildSocket()
        
        _socket?.delegate = self
        
        _log("Connecting")
        
        _socket?.connect()
    }
    
    func disconnect() {
        _attemptReconnect = false
        _socket?.disconnect()
        _socket = nil
    }
    
    func emit(_ event: String, data: [String : Any]? = nil, completion: ((String?)->Void)? = nil) {
        
        let stringToSend = _format(event: event, data: data)
        
        if let socket = _socket,
            socket.isConnected {
            
            socket.write(string: stringToSend) {
                completion?(stringToSend)
            }
            
        } else {
            _pendingMessages.append((stringToSend, completion))
        }
    }
    
    func _format(event: String, data: [String : Any]? = nil) -> String {
        
        var arr: [Any] = [event]
        
        
        if let data = data, !data.isEmpty {
            arr.append(data)
        }
        
        let dict: [String : Any] = ["type" : 0, "data" : arr]
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
            return String(data: jsonData, encoding: .utf8)?.replacingOccurrences(of: "\n", with: "\\n") ?? ""
            
        } catch {
            return ""
        }
    }
    
    func add(observer: SocketManagerObserver) {
        _observers.add(observer)
    }
    
    func remove(observer: SocketManagerObserver) {
        _observers.remove(observer)
    }
}

//MARK: - WebSocketDelegate
extension SocketManager : WebSocketDelegate {
   
    public func websocketDidConnect(socket: WebSocket) {
        _log("Connected")
        _sendPendingMessages()
        
        _notifyObserversDidConnect()
    }
    
    public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        
        _log("Disconnected  Reason:  \(error?.localizedDescription ?? "N/A")")
        
        _notifyObserversDisconnect(with: error)
        
        if _attemptReconnect {
            
            Timer.scheduledTimer(withTimeInterval: waitToReconnect, repeats: false) { [weak self] _ in
                self?._log("Attempting Reconnect")
                self?.connect()
            }
        }
    }
    
    public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        _log("Did receive string: \(text)")
        
        _handle(text)
    }
    
    public func websocketDidReceiveData(socket: WebSocket, data: Data) {
        _log("Did receive data: \(data)")
    }
}

//MARK: - Helper
fileprivate extension SocketManager {
    
    @objc func willEnterBackground() {
        _socket?.disconnect()
        _attemptReconnect = false
    }
    
    @objc func didEnterForground() {
        connect()
    }
    
    func _buildSocket() -> WebSocket? {
        
        guard let url = _buildURL() else {
            return nil
        }
        
        return WebSocket(url: url)
        
    }
    
    func _buildURL() -> URL? {
        
        guard let accessToken = UserDefaults.mfl_accessToken else {
            return nil
        }
        
        let url_query = "?accessToken=\(accessToken)"
        return URL(string: _baseUrl + url_path + url_query)
    }
    
    func _handle(_ message: String) {
        
        switch _parse(message) {
        case .ping(let ping): _pong(ping)
        case .other(let event, let data): _notifyObservers(event: event, data: data)
        }
        
    }
    
    func _parse(_ message: String) -> SocketMessageType {
        
        if message.contains(primus_ping) {
            let unwrap = message - "\""
            return .ping(unwrap - primus_ping)
        
        } else {
            let json = MFLDefaultJsonDecoder.json(with: message)
            
            if json.isEmpty { return .other(message, nil) }
            
            let array = json["data"].arrayValue
            
            let event = array[0].stringValue
            let data: MFLJson? = array.count > 1 ? array[1] : nil
            
            return .other(event, data)
        }
    }
    
    func _pong(_ string: String) {
        var pong = primus_pong + string
        pong = pong.wrapping(in: "\"")
        
        _socket?.write(string: pong) { [weak self] in
            self?._log("Sent pong:   \(pong)")
        }
    }
    
    func _sendPendingMessages() {
        
        let messagesToSend = _pendingMessages
        
        for (message, completion) in messagesToSend {
            
            _socket?.write(string: message) { [weak self] in
                
                completion?(message)
                self?._pendingMessages.remove(where: { $0.message == message })
            }
        }
    }
    
    func _notifyObserversDidConnect() {
        _observers.allObjects.forEach {
            guard let observer = $0 as? SocketManagerObserver else { return }
            observer.socketManagerDidConnect(self)
        }
    }
    
    func _notifyObserversDisconnect(with error: NSError?) {
        _observers.allObjects.forEach {
            guard let observer = $0 as? SocketManagerObserver else { return }
            observer.socketManager(self, didDisconnectWith: error)
        }
    }
     
    func _notifyObservers(event: String, data: MFLJson?) {
        _observers.allObjects.forEach {
            guard let observer = $0 as? SocketManagerObserver else { return }
            observer.socketManager(self, didReceive: event, with: data)
        }
    }
    
    func _log(_ message: String) {
        print("Socket Manager: \(message)")
    }
}

//MARK: - String + Extensions
fileprivate extension String {
    
    func wrapping(in wrapper: String) -> String {
        return "\(wrapper)\(self)\(wrapper)"
    }
}

fileprivate func -(lhs: String, rhs: String) -> String {
    return lhs.replacingOccurrences(of: rhs, with: "")
}





