//
//  MoodTagsWireframe.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 04/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class MoodTagsWireframeImplementation : MoodTagsWireframe {
    
    weak var delegate : MoodTagsWireframeDelegate?
    
    func start(_ dependecies: HasNavigationController & HasNetworkManager & HasStoryboard & HasMoodDataStore, emotion: Emotion, note: String?) {
        
        var moduleDependencies = MoodTagsDependencies()
        moduleDependencies.moodTagsWireframe = self
        moduleDependencies.moodTagDataStore = dependecies.moodDataStore.moodTagDataStore(networkManager: dependecies.networkManager)
        moduleDependencies.journalEntryDataStore = dependecies.moodDataStore.journalEntryDataStore(networkManager: dependecies.networkManager)
        moduleDependencies.moodTagsInteractor = MoodTagsFactory.interactor(moduleDependencies)
        
        var presenter = MoodTagsFactory.presenter(moduleDependencies, emotion: emotion, note: note)
        let viewController: MoodTagsViewController = dependecies.storyboard.viewController()
        
        viewController.presenter = presenter
        presenter.delegate = viewController
        
         
        dependecies.navigationController.mfl_show(viewController, sender: self)
    }
    
    func finish() {
        delegate?.moodTagsWireframeWantsToFinish(self)
    }
}


