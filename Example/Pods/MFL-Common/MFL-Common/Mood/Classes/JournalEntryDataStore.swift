//
//  JournalEntryDataStore.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 04/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

public class JournalEntryDataStoreImplementation : JournalEntryDateStore {
    
    fileprivate let _persistentStore : JournalEntryPersistentStore
    fileprivate let _networkManager : NetworkManager
    
    public init(_ dependencies: HasJournalEntryPersistentStore & HasNetworkManager) {
        _persistentStore = dependencies.journalEntryPersistentStore
        _networkManager = dependencies.networkManager
    }
    
    public func fetchJournalEntries(handler: @escaping ([JournalEntry], Error?) -> Void) {
        
        _networkManager.getJournalEntries() { [unowned self] result in
            
            switch result {
            case .success(let json): handler(self._persistentStore.journalEntries(from: json["content"]), nil)
            case .failure(_): handler(self._persistentStore.getAllJournalEntries(), nil)
            }
        }
    }
    
    public func submitJournalEntry(with emotion: Emotion, reason: String?, moodTagIds: [String]?, handler: @escaping (Result<JournalEntry>) -> Void) {
        
        _networkManager.submitJournalEntry(with: emotion, reason: reason, moodTagIds: moodTagIds) { [unowned self] result in
            
            switch result {
            case .success(let json): handler(.success(self._persistentStore.journalEntry(form: json["content"])))
            case .failure(let error): handler(.failure(error))
            }
        }
    }
    
    public func hasJournalEntries(handler: @escaping (Bool) -> Void) {
        if _persistentStore.getAllJournalEntries().count > 0 {
            handler(true)
            return
        }
        
        fetchJournalEntries { entries, _ in handler(entries.count > 0) }
    }
}
