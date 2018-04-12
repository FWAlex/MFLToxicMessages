//
//  CSActivityDataStore.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 23/10/2017.
//

import Foundation

fileprivate let activitiesRefreshRate: TimeInterval = 24 * 60 * 60 // 1 day

class CSActivityDataStoreImplementation : CSActivityDataStore {
    
    let persistentStore : CSActivityPersistentStore
    let networkManager : NetworkManager
    
    init(_ dependencies: HasCSActivityPersistentStore & HasNetworkManager) {
        persistentStore = dependencies.csActivityPersistentStore
        networkManager = dependencies.networkManager
    }
    
    func fetchActivities(handler: @escaping (Result<[CSActivity]>) -> Void) {
        if shouldUpdateActivities() {
            
            networkManager.fetchActivities { [weak self] result in
                guard let sself = self else { return }
                
                switch result {
                case .success(let json):
                    handler(.success(sself.persistentStore.activities(from: json["content"])))
                    sself.persistentStore.didUpdateActivities()
                case .failure(let error): handler(.failure(error))
                }
            }
        } else {
            handler(.success(persistentStore.fetchActivities()))
        }
    }
    
    fileprivate func shouldUpdateActivities() -> Bool {
        if let date = persistentStore.lastUpdatedDate() {
            return Date() > date.addingTimeInterval(activitiesRefreshRate)
        }
        
        return true
    }
    
    func hasUserOpenedFeature() -> Bool {
        return persistentStore.hasUserOpenedFeature()
    }
    
    func setUserDidOpenFeature() {
        persistentStore.setUserDidOpenFeature()
    }
    
    struct Activity : CSActivity {
        let id = ""
        var text = ""
        var isSelected = true
        var type : CSActivityType = .doMore
    }
    
    func addActivity(with text: String, type: CSActivityType, handler: @escaping (Result<CSActivity>) -> Void) {
        var activity = Activity()
        activity.text = text
        activity.type = type
        
        networkManager.addActivity(activity) { [weak self] result in
            guard let sself = self else { return }
            
            switch result {
            case .success(let json):
                let activity = sself.persistentStore.activity(from: json["content"])
                handler(.success(activity))
            case .failure(let error): handler(.failure(error))
            }
        }
    }
    
    func update(_ activity: CSActivity, handler: @escaping (Error?) -> Void) {
        networkManager.updateActivity(activity) { [weak self] result in
            guard let sself = self else { return }
            
            switch result {
            case .success(_):
                sself.persistentStore.update(activity)
                handler(nil)
            case .failure(let error): handler(error)
            }
        }
    }
}

