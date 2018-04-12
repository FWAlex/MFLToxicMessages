//
//  HomeEmotionsWireframe.swift
//  Pods
//
//  Created by Marc Blasi on 01/09/2017.
//
//

import UIKit

class HomeEmotionsWireframeImplementation : HomeEmotionsWireframe {
    func start(_ dependencies: HasNavigationController & HasStoryboard & HasStyle & HasNetworkManager & HasJournalEntryPersistentStore) {
        
        var emotionsDependencies = HomeEmotionsDependencies()
        emotionsDependencies.journalEntryDataStore = DataStoreFactory.journalEntryDataStore(with: dependencies)
        emotionsDependencies.HomeEmotionsWireframe = self
        emotionsDependencies.HomeEmotionsInteractor = HomeEmotionsFactory.interactor(emotionsDependencies)
        
        var presenter = HomeEmotionsFactory.presenter(emotionsDependencies)
        let viewController: HomeEmotionsViewController = dependencies.storyboard.viewController()
        viewController.title = NSLocalizedString("Journal", comment: "")
        viewController.style = dependencies.style
        viewController.presenter = presenter
        
        presenter.delegate = viewController
        
        dependencies.navigationController.pushViewController(viewController, animated: true)
    }

    
    weak var delegate : HomeEmotionsWireframeDelegate?
    
    func presentPastJournalPage() {
        delegate?.homeWireframeWantsToPresentPastJournalPage(self)
    }
    
    func presentEmotionPage(with emotion: Emotion, callback: ((Bool) -> Void)?) {
        delegate?.homeWireframe(self, wantsToPresentEmotionPageWith: emotion, callback: callback)
    }
}


