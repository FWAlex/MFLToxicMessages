//
//  MoodTagDataStoreImplementation.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 05/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

public class MoodTagDataStoreImplementation : MoodTagDataStore {
    
    fileprivate let networkManager : NetworkManager
    fileprivate let persistentStore : MoodTagPersistentStore
    
    public init(_ dependencies: HasNetworkManager & HasMoodTagPersistentStore) {
        networkManager = dependencies.networkManager
        persistentStore = dependencies.moodTagPersistentStore
    }
    
    public func fetchTags(handler: @escaping (Result<[MoodTag]>) -> Void) {
        
        let moodTags = persistentStore.getAllTags()
        
        if moodTags.count > 0 {
            handler(.success(moodTags))
            return
        }
        
        networkManager.getMoodTags() { [unowned self] result in
            switch result {
            case .success(let json):
                handler(.success(self.persistentStore.moodTags(from: json["content"])))
                
            case .failure(let error): handler(.failure(error))
            }
        }
    }
    
}
