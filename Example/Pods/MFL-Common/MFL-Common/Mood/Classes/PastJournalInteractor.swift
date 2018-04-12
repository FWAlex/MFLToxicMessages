//
//  PastJournalInteractor.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 06/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class PastJournalInteractorImplementation: PastJournalInteractor {
    
    fileprivate let journalEntryDataStore : JournalEntryDateStore
    
    init(_ dependencies: HasJournalEntryDataStore) {
        journalEntryDataStore = dependencies.journalEntryDataStore
    }
    
    func fetchJournalEntries(handler: @escaping ([JournalEntry], Error?) -> Void) {
        journalEntryDataStore.fetchJournalEntries(handler: handler)
    }
}
