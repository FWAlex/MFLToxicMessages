//
//  JournalEntryDetailFactory.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 07/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class JournalEntryDetailFactory {
    
    class func wireframe() -> JournalEntryDetailWireframe {
        return JournalEntryDetailWireframeImplementation()
    }
    
    class func presenter(journalEntry: JournalEntry) -> JournalEntryDetailPresenter {
        return JournalEntryDetailPresenterImplementation(journalEntry: journalEntry)
    }
}

