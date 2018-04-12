//
//  MoodTagsFactory.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 04/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

protocol HasMoodTagsInteractor {
    var moodTagsInteractor : MoodTagsInteractor! { get }
}

protocol HasMoodTagsWireframe {
    var moodTagsWireframe: MoodTagsWireframe! { get }
}


class MoodTagsFactory {
    
    class func wireframe() -> MoodTagsWireframe {
        return MoodTagsWireframeImplementation()
    }
    
    class func interactor(_ dependencies: MoodTagsDependencies) -> MoodTagsInteractor {
        return MoodTagsInteractorImplementation(dependencies)
    }
    
    class func presenter(_ dependencies: MoodTagsDependencies, emotion: Emotion, note: String?) -> MoodTagsPresenter {
        return MoodTagsPresenterImplementation(dependencies, emotion: emotion, note: note)
    }
}

struct MoodTagsDependencies : HasMoodTagsInteractor, HasMoodTagsWireframe, HasMoodTagDataStore, HasJournalEntryDataStore {
    var moodTagsWireframe: MoodTagsWireframe!
    var moodTagsInteractor: MoodTagsInteractor!
    var moodTagDataStore: MoodTagDataStore!
    var journalEntryDataStore: JournalEntryDateStore!
}
