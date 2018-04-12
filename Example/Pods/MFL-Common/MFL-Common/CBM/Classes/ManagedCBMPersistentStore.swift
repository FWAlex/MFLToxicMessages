//
//  ManagedCBMPersistentStore.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 06/03/2018.
//

import CoreData

class ManagedCBMPersistentStore : CBMPersistentStore {

    fileprivate let moc : NSManagedObjectContext
    fileprivate lazy var threadSafeQueue : DispatchQueue = { DispatchQueue(label: "threadSafeQueue_\(String(describing: self))") }()
    
    init(_ dependencies: HasManagedObjectContext) {
        moc = dependencies.moc
    }
    
    func sessions(from json: MFLJson, for userId: String) -> [CBMSession] {
        var sessions = [CBMSession]()
        
        let arrayOfSessions = json["sessions"].arrayValue
        for (index, sessionJson) in arrayOfSessions.enumerated() {
            var session : ManagedCBMSession!
            self.threadSafeQueue.sync {
                session = ManagedCBMSession.object(from: sessionJson, moc: moc)
                session.order_ = NSNumber(integerLiteral: index)
                session.userId_ = userId
            }
            
            sessions.append(session)
        }
        
        
        threadSafeQueue.sync { moc.saveContext() }
        return sessions
    }
    
    func getSessions(for userId: String) -> [CBMSession] {
        let request = ManagedCBMSession.request()
        let sortDescriptor = NSSortDescriptor(key:#keyPath(ManagedCBMSession.order_),
                                              ascending: true)
        
        request.predicate = NSPredicate(format: "%K == %@ AND %K == %@", #keyPath(ManagedCBMSession.userId_), userId, #keyPath(ManagedCBMSession.done_), NSNumber(value: false))
        request.sortDescriptors = [sortDescriptor]
        
        var sessions = [CBMSession]()
        threadSafeQueue.sync { sessions = moc.contextFetch(request) }
        return sessions
    }
    
    func getStartedSession() -> CBMSession? {
        let request = ManagedCBMSession.request()
        request.predicate = NSPredicate(format: "%K == YES", #keyPath(ManagedCBMSession.isStarted_))
        
        var session : CBMSession? = nil
        threadSafeQueue.sync { session = moc.contextFetch(request).first }
        return session
    }
    
    func markSessiosnWithId(session id: String, asDone done: Bool) {
        let request = ManagedCBMSession.request()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(ManagedCBMSession.id_), id)

        threadSafeQueue.sync {
            let session = moc.contextFetch(request).first
            session?.done_ = done
        }
    }
    
    func save(_ session: CBMSession) {
        guard session is ManagedCBMSession else {
            preconditionFailure("The provided session: \(session), is not a ManagedCBMSession.")
            return
        }
        
        threadSafeQueue.sync { self.moc.saveContext() }
    }
    
    func save() {
        threadSafeQueue.sync { self.moc.saveContext() }
    }
}
