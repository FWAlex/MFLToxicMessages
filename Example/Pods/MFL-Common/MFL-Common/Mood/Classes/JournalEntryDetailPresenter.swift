//
//  JournalEntryDetailPresenter.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 07/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class JournalEntryDetailPresenterImplementation: JournalEntryDetailPresenter {

    fileprivate let journalEntry : JournalEntry
    
    init(journalEntry: JournalEntry) {
        self.journalEntry = journalEntry
    }
    
    var note : String? {
        return journalEntry.reason
    }
    
    var journalEntryHasNode : Bool {
        return !mfl_nilOrEmpty(journalEntry.reason)
    }
    
    var journalEntryHasTags : Bool {
        return numberOfTags > 0
    }
    
    func moodTag(at index: Int) -> String? {
        return journalEntry.moodTags?[index]
    }
    
    var numberOfTags : Int {
        guard let tags = journalEntry.moodTags else { return 0 }
        return tags.count
    }
}
