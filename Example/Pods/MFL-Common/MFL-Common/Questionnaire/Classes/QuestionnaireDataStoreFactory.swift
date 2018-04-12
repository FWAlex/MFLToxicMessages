//
//  QuestionnaireDataStoreFactory.swift
//  Pods
//
//  Created by Alex Miculescu on 16/10/2017.
//

import CoreData

class QuestionnaireDataStoreDependencies : HasManagedObjectContext, HasNetworkManager, HasQuestionnairePersistentStore {
    private static var coreDataStack : MFLCoreDataStack?
    
    var moc : NSManagedObjectContext! { return _moc() }
    
    private func _moc() -> NSManagedObjectContext {
        if let moc = QuestionnaireDataStoreDependencies.coreDataStack?.moc { return moc }
        
        let coreDataStack = MFLCoreDataStack(modelName: "Questionnaire", in: .questionnaire)
        QuestionnaireDataStoreDependencies.coreDataStack = coreDataStack
        
        NotificationCenter.default.addObserver(forName: MFLLogoutNotification, object: nil, queue: OperationQueue.main) { _ in
            QuestionnaireDataStoreDependencies.coreDataStack?.dropAllData()
        }
        
        return coreDataStack.moc
    }
    
    
    var networkManager: NetworkManager!
    lazy var questionnairePersistentStore: QuestionnairePersistentStore! = {
        return QuestionnairePersistentStoreImplementation(self)
    }()
}

public extension DataStoreFactory {
    class func questionnaireDataStore(with networkManager: NetworkManager) -> QuestionnaireDataStore {
        let dependencies = QuestionnaireDataStoreDependencies()
        dependencies.networkManager = networkManager
        return QuestionnaireDataStoreImplementation(dependencies)
    }
}


