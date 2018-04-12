//
//  ManagedObjectContext+Extensions.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 28/09/2017.
//

import CoreData

public extension NSManagedObjectContext {
    
    func saveContext() {
        
        guard hasChanges else { return }
        
        do {
            try save()
        } catch let error{
            print( error)
        }
        
        
    }
    
    func contextFetch<T : NSFetchRequestResult>(_ fetchRequest: NSFetchRequest<T>) -> [T] {
        
        var results = [T]()
        
        do {
            results = try fetch(fetchRequest)
        } catch {
            print(error)
        }
        
        return results
    }
}

open class ManagedObject: NSManagedObject, ManagedObjectType {
    public static var entityName: String {
        
        // As a convention we're prefixing NSManagedObject subclasses with "Managed" but not the entity names.
        let className = String(describing: self)
        let index = className.index(className.startIndex, offsetBy: 7)
        
        return className.substring(from: index) // Strip "Managed" prefix
    }
    
    lazy var threadSafeQueue : DispatchQueue = { return DispatchQueue(label: "managedObjectTreadSafeQueue_\(String(describing: self))") }()
}

public protocol ManagedObjectType: class {
    
    static var entityName: String { get }
}

public protocol JSONDecodableManagedObject {
    static func object(from json: MFLJson, moc: NSManagedObjectContext) -> Self
    static func object(from json: MFLJson, moc: NSManagedObjectContext, index: Int?) -> Self
}

public extension JSONDecodableManagedObject {
    static func object(from json: MFLJson, moc: NSManagedObjectContext, index: Int? = nil) -> Self {
        return self.object(from: json, moc: moc)
    }
}
