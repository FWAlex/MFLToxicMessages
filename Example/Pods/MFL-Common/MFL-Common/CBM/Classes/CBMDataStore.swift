//
//  CBMDataStore.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 06/03/2018.
//

import Foundation

class CBMDataStoreImplementation : CBMDataStore {
    
    fileprivate let networkManager : NetworkManager
    fileprivate let persistentStore : CBMPersistentStore
    
    init(_ dependencies: HasNetworkManager & HasCBMPersistentStore) {
        networkManager = dependencies.networkManager
        persistentStore = dependencies.cbmPersistentStore
    }
    
    func fetchCBMSessions(for userId: String, handler: @escaping (Result<[CBMSession]>) -> Void) {
        let sessions = persistentStore.getSessions(for: userId)
        if sessions.count > 0 {
            handler(.success(sessions))
            return
        }
        
        networkManager.fetchCBMSessions(for: userId) { [weak self] result in
            
            switch result {
            case .success(let json):
                let sessions = self?.persistentStore.sessions(from: json["content"], for: userId)
                handler(.success(sessions ?? [CBMSession]()))
            case .failure(let error): handler(.failure(error))
            }
        }
    }
    
    func finishSession(_ id: String) {
        persistentStore.markSessiosnWithId(session: id, asDone: true)
        persistentStore.save()
    }
}

//MARK: - Helper
private extension CBMDataStoreImplementation {
    
    
}
