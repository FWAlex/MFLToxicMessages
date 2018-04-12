//
//  PastJournalWireframe.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 06/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class PastJournalWireframeImplementation : PastJournalWireframe {
    
    weak var delegate : PastJournalWireframeDelegate?
    
    func start(_ dependencies: HasStoryboard & HasNavigationController & HasNetworkManager & HasMoodDataStore) {
        
        var moduleDependencies = PastJournalDependencies()
        moduleDependencies.pastJournalWireframe = self
        moduleDependencies.journalEntryDataStore = dependencies.moodDataStore.journalEntryDataStore(networkManager: dependencies.networkManager)
        moduleDependencies.pastJournalInteractor = PastJournalFactory.interactor(moduleDependencies)
        
        let viewController: PastJournalViewController = dependencies.storyboard.viewController()
        var presenter = PastJournalFactory.presenter(moduleDependencies)
        
        viewController.presenter = presenter
        presenter.delegate = viewController
        
        viewController.title = NSLocalizedString("Moods", comment: "")
        
        dependencies.navigationController.viewControllers = [viewController]
    }
    
    func presentDetails(for journalEntry: JournalEntry) {
        delegate?.pastJournalWireframe(self, wantsToPresentDetailsFor: journalEntry)
    }
    
    func close() {
        delegate?.pastJournalWireframeDidFinish(self)
    }
}


