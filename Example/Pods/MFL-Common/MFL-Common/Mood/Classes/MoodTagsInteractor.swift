//
//  MoodTagsInteractor.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 04/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class MoodTagsInteractorImplementation: MoodTagsInteractor {

    fileprivate let moodTagDataStore : MoodTagDataStore
    fileprivate let journalEntryDataStore : JournalEntryDateStore
    
    init(_ dependencies: HasMoodTagDataStore & HasJournalEntryDataStore) {
        moodTagDataStore = dependencies.moodTagDataStore
        journalEntryDataStore = dependencies.journalEntryDataStore
    }
    
    func fetchMoodTags(handler: @escaping (Result<[MoodTag]>) -> Void) {
        moodTagDataStore.fetchTags(handler: handler)
    }
    
    func submitJournalEntry(with emotion: Emotion, reason: String?, moodTagIds: [String]?, handler: @escaping (Error?) -> Void) {
        
        journalEntryDataStore.submitJournalEntry(with: emotion, reason: reason, moodTagIds: moodTagIds) {
            switch $0 {
            case .success(_): handler(nil)
            case .failure(let error): handler(error)
            }
        }
    }
    
}
