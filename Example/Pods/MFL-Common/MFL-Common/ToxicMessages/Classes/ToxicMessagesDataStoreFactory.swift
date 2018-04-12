//
//  ToxicMessagesDataStoreFactory.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 29/11/2017.
//

import CoreData

struct FinkelhorDataStoreDependencies : HasManagedObjectContext, HasFinkelhorPersistentStore {
    
    private static var coreDataStack : MFLCoreDataStack?
    
    var moc : NSManagedObjectContext! { return _moc() }
    
    private func _moc() -> NSManagedObjectContext {
        if let moc = FinkelhorDataStoreDependencies.coreDataStack?.moc { return moc }
        
        let coreDataStack = MFLCoreDataStack(modelName: "ToxicMessages", in: .toxicMessages)
        FinkelhorDataStoreDependencies.coreDataStack = coreDataStack
        
        NotificationCenter.default.addObserver(forName: MFLLogoutNotification, object: nil, queue: OperationQueue.main) { _ in
            FinkelhorDataStoreDependencies.coreDataStack?.dropAllData()
        }
        
        return coreDataStack.moc
    }
    
    var finkelhorPersistentStore: FinkelhorPersistentStore! {
        return ManagedFinkelhorPersistentStore(self)
    }
}

extension DataStoreFactory {
    
    static func finkelhorDataStore() -> FinkelhorDataStore {
        var dataStoreDependencies = FinkelhorDataStoreDependencies()
        return FinkelhorDataStoreImplementation(dataStoreDependencies)
    }
}

