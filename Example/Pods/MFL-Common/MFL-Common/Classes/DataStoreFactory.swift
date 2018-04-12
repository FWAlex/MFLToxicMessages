//
//  DataStoreFactory.swift
//  Pods
//
//  Created by Alex Miculescu on 14/09/2017.
//
//

import Foundation


open class DataStoreFactory {
    
    //MARK: - BoltonDataStore
    public class func boltonDataStore(with dependencies: HasNetworkManager) -> BoltonDataStore! {
        return BoltonDataStoreImplementation(dependencies)
    }
    
    //MARK: - PackageDataStore
    public class func packageDataStore(with dependencies: HasNetworkManager & HasPackagePersistentStore) -> PackageDataStore {
        return PackageDataStoreImplementation(dependencies)
    }
    
    public class func packageDataStore(with networkManager: NetworkManager, and persistentStore: PackagePersistentStore) -> PackageDataStore {
        var dependencies = FactoryDependencies()
        dependencies.networkManager = networkManager
        dependencies.packagePersistentStore = persistentStore
        return PackageDataStoreImplementation(dependencies)
    }
    
    //MARK: - UserDataStore
    public class func userDataStore(with dependencies: HasUserPresistentStore & HasNetworkManager) -> UserDataStore {
        return UserDataStoreImplementation(dependencies)
    }
    
    public class func userDataStore(with networkManager: NetworkManager, and persistentStore: UserPersistentStore) -> UserDataStore {
        var dependencies = FactoryDependencies()
        dependencies.networkManager = networkManager
        dependencies.userPersistentStore = persistentStore
        return UserDataStoreImplementation(dependencies)
    }
    
    //MARK: - GoalDataStore
    public class func goalDataStore(with dependencies: HasNetworkManager & HasGoalPersistentStore) -> GoalDataStore {
        return GoalDataStoreImplementation(dependencies)
    }
    
    public class func goalDataStore(with networkManager: NetworkManager, and persistentStore: GoalPersistentStore) -> GoalDataStore {
        var dependencies = FactoryDependencies()
        dependencies.networkManager = networkManager
        dependencies.goalPersistentStore = persistentStore
        return GoalDataStoreImplementation(dependencies)
    }
    
    //MARK: - JournalEntryDateStore
    public class func journalEntryDataStore(with dependencies: HasNetworkManager & HasJournalEntryPersistentStore) -> JournalEntryDateStore {
        return JournalEntryDataStoreImplementation(dependencies)
    }
    
    public class func journalEntryDataStore(with networkManager: NetworkManager, and persistentStore: JournalEntryPersistentStore) -> JournalEntryDateStore {
        var dependencies = FactoryDependencies()
        dependencies.networkManager = networkManager
        dependencies.journalEntryPersistentStore = persistentStore
        return JournalEntryDataStoreImplementation(dependencies)
    }
    
    //MARK: - MoodTagDataStore
    public class func moodTagDataStore(with dependencies: HasNetworkManager & HasMoodTagPersistentStore) -> MoodTagDataStore {
        return MoodTagDataStoreImplementation(dependencies)
    }
    
    public class func moodTagDataStore(with networkManager: NetworkManager, and persistentStore: MoodTagPersistentStore) -> MoodTagDataStore {
        var dependencies = FactoryDependencies()
        dependencies.networkManager = networkManager
        dependencies.moodTagPersistentStore = persistentStore
        return MoodTagDataStoreImplementation(dependencies)
    }
    
    public class func stageDataStore(with dependencies: HasNetworkManager & HasStagePersistentStore, localStagesURL: URL) -> StageDataStore {
        return StageDataStoreImplementation(dependencies, localStagesURL: localStagesURL)
    }
    
    public class func stageDataStore(with networkManager: NetworkManager, and persistentStore: StagePersistentStore, localStagesURL: URL) -> StageDataStore {
        var dependencies = FactoryDependencies()
        dependencies.networkManager = networkManager
        dependencies.stagePersistentStore = persistentStore
        return StageDataStoreImplementation(dependencies, localStagesURL: localStagesURL)
    }
}

fileprivate struct FactoryDependencies : HasNetworkManager, HasUserPresistentStore, HasGoalPersistentStore, HasPackagePersistentStore, HasJournalEntryPersistentStore, HasMoodTagPersistentStore, HasStagePersistentStore {
    var networkManager : NetworkManager!
    var userPersistentStore : UserPersistentStore!
    var goalPersistentStore : GoalPersistentStore!
    var packagePersistentStore : PackagePersistentStore!
    var journalEntryPersistentStore : JournalEntryPersistentStore!
    var moodTagPersistentStore : MoodTagPersistentStore!
    var stagePersistentStore: StagePersistentStore!
}
