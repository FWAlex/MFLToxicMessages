//
//  MessageDataStoreInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 24/05/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

protocol HasMessagePersistentStore {
    var messagePersistentStore : MessagePersistentStore! { get }
}

public protocol HasMessageDataStore {
    var messageDataStore : MessageDataStore! { get }
}

public protocol MessageDataStore {
    func send(message: String, handler: @escaping (Result<Message>) -> Void)
    func message(from json: MFLJson) -> Message
    func getMessages(after message: Message, handler: @escaping ([Message]) -> Void)
    func getMessages(offset: Int, handler: @escaping ([Message]) -> Void)
}

protocol MessagePersistentStore {
    func message(from json: MFLJson) -> Message
    func messages(from json: MFLJson) -> ([Message], Bool)
    func messages(from json: MFLJson, before currentMessage: Message?) -> ([Message], Bool)
    func messages(limit: Int, offset: Int) -> [Message]
}

