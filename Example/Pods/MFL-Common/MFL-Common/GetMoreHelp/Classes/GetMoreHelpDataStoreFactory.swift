//
//  GetMoreHelpDataStoreFactory.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 16/10/2017.
//

import CoreData

struct GetMoreHelpDataStoreDependencies : HasManagedObjectContext, HasMessagePersistentStore, HasNetworkManager, HasTeamMemberPersistentStore {
    private static var coreDataStack : MFLCoreDataStack?
    
    var networkManager: NetworkManager!
    var moc : NSManagedObjectContext! { return _moc() }
    
    private func _moc() -> NSManagedObjectContext {
        if let moc = GetMoreHelpDataStoreDependencies.coreDataStack?.moc { return moc }
        
        let coreDataStack = MFLCoreDataStack(modelName: "GetMoreHelp", in: .getMoreHelp)
        GetMoreHelpDataStoreDependencies.coreDataStack = coreDataStack
        
        NotificationCenter.default.addObserver(forName: MFLLogoutNotification, object: nil, queue: OperationQueue.main) { _ in
            GetMoreHelpDataStoreDependencies.coreDataStack?.dropAllData()
        }
        
        return coreDataStack.moc
    }
    
    var messagePersistentStore : MessagePersistentStore! {
        return ManagedMessagePersistentStore(self)
    }
    
    var teamMemberPersistentStore : TeamMemberPersistentStore! {
        return ManagedTeamMemberPersistentStore(self)
    }
}

public extension DataStoreFactory {
    
    public static func messageDataStore(with networkManager: NetworkManager) -> MessageDataStore {
        var dataStoreDependencies = GetMoreHelpDataStoreDependencies()
        dataStoreDependencies.networkManager = networkManager
        
        return MessageDataStoreImplementation(dataStoreDependencies)
    }
}


extension DataStoreFactory {
    
    static func teamMemberDataStore(with networkManager: NetworkManager) -> TeamMemberDataStore {
        var dataStoreDependencies = GetMoreHelpDataStoreDependencies()
        dataStoreDependencies.networkManager = networkManager
        
        return TeamMemberDataStoreImplementation(dataStoreDependencies)
    }
}

