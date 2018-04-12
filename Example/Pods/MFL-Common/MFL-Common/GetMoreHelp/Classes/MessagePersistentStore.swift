//
//  MessagePersistentStore.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 24/05/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import CoreData

class ManagedMessagePersistentStore : MessagePersistentStore {
    
    fileprivate let _moc : NSManagedObjectContext
    
    typealias Dependencies = HasManagedObjectContext
    init(_ dependencies: Dependencies) {
        _moc = dependencies.moc
    }
    
    func message(from json: MFLJson) -> Message {
        let message = ManagedMessage.object(from: json, moc: _moc)
        _moc.saveContext()
        
        return message
    }
    
    func messages(from json: MFLJson) -> ([Message], Bool) {
        return messages(from: json, before: nil)
    }
    
    func messages(from json: MFLJson, before currentMessage: Message?) -> ([Message], Bool) {
        var messages = [Message]()
        
        for jsonObject in json["results"].arrayValue {
            if jsonObject["id"].stringValue == currentMessage?.id {
                _moc.saveContext()
                return (messages, true)
            }
            let message = ManagedMessage.object(from: jsonObject, moc: _moc)
            messages.append(message)
        }
        
        _moc.saveContext()
        return (messages, false)
    }
    
    func messages(limit: Int, offset: Int) -> [Message] {
        
        let fetchRequest = ManagedMessage.request()
        fetchRequest.fetchLimit = limit
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(ManagedMessage.sentAt_), ascending: true)]
        
        do {
            let messages = try _moc.fetch(fetchRequest)
            return messages
        } catch {
            return [ManagedMessage]()
        }
    }
}
