//
//  HomeEmotionsInteractor.swift
//  Pods
//
//  Created by Marc Blasi on 01/09/2017.
//
//

import Foundation

class HomeEmotionsInteractorImplementation: HomeEmotionsInteractor {
    fileprivate let journalEntryDataStore : JournalEntryDateStore
    
    typealias Dependencies = HasJournalEntryDataStore
    
    init(_ dependencies: Dependencies) {
        journalEntryDataStore = dependencies.journalEntryDataStore
    }
    
    func hasJournalEntries(handler: @escaping (Bool) -> Void) {
        journalEntryDataStore.hasJournalEntries(handler: handler)
    }
}
