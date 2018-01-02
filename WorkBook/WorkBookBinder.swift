//
//  WorkBookBinder.swift
//  WorkBook
//
//  Created by Aliaksandr Kantsevoi on 9/16/17.
//  Copyright © 2017 Aliaksandr Kantsevoi. All rights reserved.
//

import Foundation
import Starscream

private enum Constants {
    static let retrySeconds: UInt64 = 5
}

public class WorkbookBinder<T: Codable>: WebSocketDelegate {
    private let socket: WebSocket
    private let tag: String
    private let resourceKey: String
    
    private var callBacks: [(T)->Void] = []
    private var value: T
    
    public init(value: T, resourceKey: String) {
        self.socket = WebSocket(url: WorkBookConstants.resourceURL(resourceKey))
        self.tag = "Binder<\(T.self)-\(resourceKey)>"
        self.value = value
        self.resourceKey = resourceKey
        socket.delegate = self
        socket.connect()
    }
    
    public func update(value: T) {
        self.value = value
        callBacks.forEach{ $0(value) }
        sendCurrentValue()
    }
    
    public func subscribe(callBack: @escaping (T)->Void) {
        callBacks.append(callBack)
        callBack(self.value)
    }
    
    // MARK: WebSocketDelegate
    public func websocketDidConnect(socket: WebSocketClient) {
        WorkBookLogger.log(tag: self.tag, message: "Did connect")
        
        sendCurrentValue()
    }
    
    public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        WorkBookLogger.log(tag: self.tag, message: "Did disconnect")
        
        retry()
    }
    
    public func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        WorkBookLogger.log(tag: self.tag, message: "Did receive message: \(text)")
        let jsonDecoder = JSONDecoder()
        let jsonData = text.data(using: String.Encoding.utf8)!
        do {
            let object = try jsonDecoder.decode([String: T].self, from: jsonData)
            if let value = object[self.resourceKey] {
                localUpdate(value: value)
            }
        } catch {
            WorkBookLogger.log(tag: self.tag, message: "Error parse message")
        }
    }
    
    public func websocketDidReceiveData(socket: WebSocketClient, data: Data) {}
    
    private func retry() {
        WorkBookLogger.log(tag: self.tag, message: "Run retry connection in \(Constants.retrySeconds)s")
        
        let afterTime = DispatchTime.now() + Double(Constants.retrySeconds)
        DispatchQueue.main.asyncAfter(deadline: afterTime) {
            self.socket.connect()
        }
    }
    
    private func localUpdate(value: T) {
        self.value = value
        callBacks.forEach{ $0(value) }
    }
    
    private func sendCurrentValue() {
        let jsonEncoder = JSONEncoder()
        let object = [resourceKey: self.value]
        let jsonData = try! jsonEncoder.encode(object)
        let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!
        
        socket.write(string: jsonString)
    }
}
 
