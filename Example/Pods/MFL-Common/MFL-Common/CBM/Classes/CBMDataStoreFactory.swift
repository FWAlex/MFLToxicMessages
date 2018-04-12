//
//  CBMDataStoreFactory.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 06/03/2018.
//

import CoreData

struct CBMDataStoreDependencies : HasManagedObjectContext, HasCBMPersistentStore, HasNetworkManager {
    
    private static var coreDataStack : MFLCoreDataStack?
    
    var moc : NSManagedObjectContext! { return _moc() }
    
    private func _moc() -> NSManagedObjectContext {
        if let moc = CBMDataStoreDependencies.coreDataStack?.moc { return moc }
        
        let coreDataStack = MFLCoreDataStack(modelName: "CBM", in: .cbm)
        CBMDataStoreDependencies.coreDataStack = coreDataStack
        
        NotificationCenter.default.addObserver(forName: MFLLogoutNotification, object: nil, queue: OperationQueue.main) { _ in
            CBMDataStoreDependencies.coreDataStack?.dropAllData()
        }
        
        return coreDataStack.moc
    }
    
    var cbmPersistentStore: CBMPersistentStore! {
        return ManagedCBMPersistentStore(self)
    }
    
    var networkManager: NetworkManager!
}

extension DataStoreFactory {
    
    static func cbmDataStore(_ dependencies: HasNetworkManager) -> CBMDataStore {
        var dataStoreDependencies = CBMDataStoreDependencies()
        dataStoreDependencies.networkManager = dependencies.networkManager
        return CBMDataStoreImplementation(dataStoreDependencies)
    }
}

