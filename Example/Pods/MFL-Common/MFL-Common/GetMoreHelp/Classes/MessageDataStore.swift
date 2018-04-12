//
//  MessageDataStore.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 25/09/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

fileprivate let maxMessagesLimit = 50

class MessageDataStoreImplementation : MessageDataStore {
    
    fileprivate let persistentStore : MessagePersistentStore
    fileprivate let networkManager : NetworkManager
    
    init(_ dependencies: HasMessagePersistentStore & HasNetworkManager) {
        persistentStore = dependencies.messagePersistentStore
        networkManager = dependencies.networkManager
    }
    
    func send(message: String, handler: @escaping (Result<Message>) -> Void) {
        networkManager.sendRTC(message: message) { [unowned self] result in
            switch result {
            case .success(let json): handler(.success(self.persistentStore.message(from: json["content"])))
            case .failure(_): break
            }
        }
    }
    
    func message(from json: MFLJson) -> Message {
        return persistentStore.message(from: json)
    }
    
    func getMessages(after message: Message, handler: @escaping ([Message]) -> Void) {
        getMessages(after: message, offset: 0, messages: [Message](), handler: handler)
    }
    
    fileprivate func getMessages(after message: Message, offset: Int, messages: [Message], handler: @escaping ([Message]) -> Void) {
        
        var newMessages = Array(messages)
        
        networkManager.retrieveMessages(offset: offset, limit: maxMessagesLimit) { [unowned self] result in
            switch result {
            case .success(let json):
                let tuple = self.persistentStore.messages(from: json["content"], before: message)
                newMessages.insert(contentsOf: tuple.0.reversed(), at: 0)
                if tuple.1 { handler(newMessages) }
                else { self.getMessages(after: message, offset: offset + maxMessagesLimit, messages: newMessages, handler: handler) }
                
            case .failure(_): handler([Message]())
            }
        }
    }
    
    func getMessages(offset: Int, handler: @escaping ([Message]) -> Void) {
        networkManager.retrieveMessages(offset: offset, limit: maxMessagesLimit) { [unowned self] result in
            switch result {
            case .success(let json): handler(self.persistentStore.messages(from: json["content"]).0.reversed())
            case .failure(_): handler(self.persistentStore.messages(limit: maxMessagesLimit, offset: offset))
            }
        }
    }
}
