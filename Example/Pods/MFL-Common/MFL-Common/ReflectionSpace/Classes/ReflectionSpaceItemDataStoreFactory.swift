//
//  ReflectionSpaceItemDataStoreFactory.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 16/10/2017.
//

import CoreData

class ReflectionSpaceItemDataStoreDependencies : HasManagedObjectContext, HasReflectionSpaceItemPersistentStore {
    private static var coreDataStack : MFLCoreDataStack?
    
    var moc : NSManagedObjectContext! { return _moc() }
    
    private func _moc() -> NSManagedObjectContext {
        if let moc = ReflectionSpaceItemDataStoreDependencies.coreDataStack?.moc { return moc }
        
        let coreDataStack = MFLCoreDataStack(modelName: "ReflectionSpace", in: .reflectionSpace)
        ReflectionSpaceItemDataStoreDependencies.coreDataStack = coreDataStack
        
        NotificationCenter.default.addObserver(forName: MFLLogoutNotification, object: nil, queue: OperationQueue.main) { _ in
            ReflectionSpaceItemDataStoreDependencies.coreDataStack?.dropAllData()
        }
        
        return coreDataStack.moc
    }
    
    var reflectionSpaceItemPersistentStore: ReflectionSpaceItemPersistentStore! {
        return ManagedReflectionSpaceItemPersistentStore(self)
    }
}

extension DataStoreFactory {
    
    class func reflectionSpaceItemDataStore() -> ReflectionSpaceItemDataStore {
        return ReflectionSpaceItemDataStoreImplementation(ReflectionSpaceItemDataStoreDependencies())
    }
    
}
