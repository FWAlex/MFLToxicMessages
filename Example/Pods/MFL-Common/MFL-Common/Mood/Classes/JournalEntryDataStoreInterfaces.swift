//
//  JournalEntryDataStoreInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 04/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

public protocol JournalEntryDateStore {
    func submitJournalEntry(with emotion: Emotion, reason: String?, moodTagIds: [String]?, handler: @escaping (Result<JournalEntry>) -> Void)
    func fetchJournalEntries(handler: @escaping ([JournalEntry], Error?) -> Void)
    func hasJournalEntries(handler: @escaping (Bool) -> Void)
}

public protocol JournalEntryPersistentStore {
    func journalEntries(from json: MFLJson) -> [JournalEntry]
    func journalEntry(form json: MFLJson) -> JournalEntry
    func journalEntry(with id: String) -> JournalEntry?
    func getAllJournalEntries() -> [JournalEntry]
}
