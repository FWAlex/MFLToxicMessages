//
//  ManagedCBMSession.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 07/03/2018.
//

import Foundation
import CoreData

final class ManagedCBMSession: ManagedObject, JSONDecodableManagedObject {
    
    @nonobjc public class func request() -> NSFetchRequest<ManagedCBMSession> {
        return NSFetchRequest<ManagedCBMSession>(entityName: "CBMSession");
    }
    
    @NSManaged var id_ : String
    @NSManaged var kind_ : String
    @NSManaged var order_ : NSNumber
    @NSManaged var trials_ : NSOrderedSet
    @NSManaged var isStarted_ : Bool
    @NSManaged var userId_: String
    @NSManaged var done_: Bool
    
    static func object(from json: MFLJson, moc: NSManagedObjectContext) -> ManagedCBMSession {
        var cbmSession : ManagedCBMSession? = nil
        
//        threadSafeQueue.sync {
            deleteOldSession(with: json["id"].stringValue, moc: moc)
            cbmSession = moc.insertObject()
            cbmSession?.id_ = json["id"].stringValue
            cbmSession?.kind_ = json["kind"].stringValue
            cbmSession?.isStarted_ = false
            cbmSession?.done_ = false
            let trials = NSMutableOrderedSet()
            json["trials"].arrayValue.forEach { trials.add(ManagedCBMTrial.object(from: $0, moc: moc)) }
            cbmSession?.trials_ = trials
//        }
        
        return cbmSession!
    }
    
    private static func deleteOldSession(with id: String, moc: NSManagedObjectContext) {
        let request = self.request()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(ManagedCBMSession.id_), id)
        if let oldCBMSession = moc.contextFetch(request).first {
            moc.delete(oldCBMSession)
        }
    }
}

extension ManagedCBMSession : CBMSession {
    
    var id : String {
        var id = ""
        threadSafeQueue.sync { id = id_ }
        return id
    }
    
    var userId : String {
        var id = ""
        threadSafeQueue.sync { id = userId_ }
        return id
    }
    var order: Int {
        var order: Int = 0
        threadSafeQueue.sync { order = order_.intValue }
        return order
    }
    var kind : String {
        var kind = ""
        threadSafeQueue.sync { kind = kind_ }
        return kind
    }
    
    var trials : [CBMTrial] {
        var trials : [CBMTrial]? = nil
        threadSafeQueue.sync { trials = trials_.array as! [CBMTrial] }
        return trials!
    }
    
    var isStarted : Bool {
        get {
            var isStarted = false
            threadSafeQueue.sync { isStarted = isStarted_ }
            return isStarted
        }
        set {
            threadSafeQueue.sync { isStarted_ = newValue }
        }
    }
    
    
}
