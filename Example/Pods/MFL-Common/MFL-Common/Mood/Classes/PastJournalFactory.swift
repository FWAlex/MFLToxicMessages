//
//  PastJournalFactory.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 06/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

protocol HasPastJournalInteractor {
    var pastJournalInteractor : PastJournalInteractor! { get }
}

protocol HasPastJournalWireframe {
    var pastJournalWireframe: PastJournalWireframe! { get }
}


class PastJournalFactory {
    
    class func wireframe() -> PastJournalWireframe {
        return PastJournalWireframeImplementation()
    }
    
    class func interactor(_ dependencies: PastJournalDependencies) -> PastJournalInteractor {
        return PastJournalInteractorImplementation(dependencies)
    }
    
    class func presenter(_ dependencies: PastJournalDependencies) -> PastJournalPresenter {
        return PastJournalPresenterImplementation(dependencies)
    }
}

struct PastJournalDependencies : HasPastJournalInteractor, HasPastJournalWireframe, HasJournalEntryDataStore {
    var pastJournalWireframe: PastJournalWireframe!
    var pastJournalInteractor: PastJournalInteractor!
    var journalEntryDataStore: JournalEntryDateStore!
}
