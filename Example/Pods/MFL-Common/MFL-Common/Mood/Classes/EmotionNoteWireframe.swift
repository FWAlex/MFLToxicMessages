//
//  EmotionNoteWireframe.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 30/06/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class EmotionNoteWireframeImplementation : EmotionNoteWireframe {
    
    weak var delegate : EmotionNoteWireframeDelegate?
    
    func start(_ dependencies: HasStoryboard & HasNavigationController & HasNetworkManager & HasMoodDataStore, emotion: Emotion) {
        
        var moduleDependencies = EmotionNoteDependencies()
        moduleDependencies.emotionNoteWireframe = self
        moduleDependencies.journalEntryDataStore = dependencies.moodDataStore.journalEntryDataStore(networkManager: dependencies.networkManager)
        moduleDependencies.emotionNoteInteractor = EmotionNoteFactory.interactor(moduleDependencies)
        
        let viewController: EmotionNoteViewController = dependencies.storyboard.viewController()
        var presenter = EmotionNoteFactory.presenter(moduleDependencies, emotion: emotion)
        
        viewController.presenter = presenter
        presenter.delegate = viewController
        
        dependencies.navigationController.viewControllers = [viewController]
    }
    
    func presentTagsPage(with note: String?) {
        delegate?.emotionNoteWireframe(self, wantsToPresentTagsPageWith: note)
    }
    
    func finish(success: Bool) {
        delegate?.emotionNoteWireframe(self, didFinishWithSuccess: success)
    }
    
    func cancel() {
        self.delegate?.emotionNoteWireframeDidCancel(self)
        
    }
}
