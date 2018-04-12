//
//  EmotionNoteInteractor.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 30/06/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class EmotionNoteInteractorImplementation: EmotionNoteInteractor {
    
    fileprivate let _journalEntryDataStore : JournalEntryDateStore
    
    init(_ dependencies: HasJournalEntryDataStore) {
        _journalEntryDataStore = dependencies.journalEntryDataStore
    }
    
    func submitJournalEntry(with emotion: Emotion, reason: String?, handler: @escaping (Error?) -> Void) {
        
        _journalEntryDataStore.submitJournalEntry(with: emotion, reason: reason, moodTagIds: nil) { result in
            switch result {
            case .success(_): handler(nil)
            case .failure(let error): handler(error)
            }
        }
    }
    
}
