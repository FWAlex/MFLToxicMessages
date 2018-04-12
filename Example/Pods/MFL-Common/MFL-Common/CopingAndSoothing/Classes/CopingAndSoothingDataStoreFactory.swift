//
//  CopingAndSoothingDataStoreFactory.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 24/10/2017.
//

import CoreData

fileprivate struct CopingAndSoothingDataStoreDependencies : HasManagedObjectContext, HasNetworkManager, HasCSActivityPersistentStore {
    private static var coreDataStack : MFLCoreDataStack?
    
    var networkManager: NetworkManager!
    var moc : NSManagedObjectContext! { return _moc() }
    
    private func _moc() -> NSManagedObjectContext {
        if let moc = CopingAndSoothingDataStoreDependencies.coreDataStack?.moc { return moc }
        
        let coreDataStack = MFLCoreDataStack(modelName: "CopingAndSoothing", in: .copingAndSoothing)
        CopingAndSoothingDataStoreDependencies.coreDataStack = coreDataStack
        
        NotificationCenter.default.addObserver(forName: MFLLogoutNotification, object: nil, queue: OperationQueue.main) { _ in
            CopingAndSoothingDataStoreDependencies.coreDataStack?.dropAllData()
        }
        
        return coreDataStack.moc
    }
    
    var csActivityPersistentStore: CSActivityPersistentStore! {
        return ManagedCSActivityPersistentStore(self)
    }
}

extension DataStoreFactory {
    static func csActivityDataStore(networkManager: NetworkManager) -> CSActivityDataStore {
        var dependencies = CopingAndSoothingDataStoreDependencies()
        dependencies.networkManager = networkManager
        return CSActivityDataStoreImplementation(dependencies)
    }
}
