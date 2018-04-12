//
//  EmotionNoteFactory.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 30/06/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

protocol HasEmotionNoteInteractor {
    var emotionNoteInteractor : EmotionNoteInteractor! { get }
}

protocol HasEmotionNoteWireframe {
    var emotionNoteWireframe: EmotionNoteWireframe! { get }
}


class EmotionNoteFactory {
    
    class func wireframe() -> EmotionNoteWireframe {
        return EmotionNoteWireframeImplementation()
    }
    
    class func interactor(_ dependencies: EmotionNoteDependencies) -> EmotionNoteInteractor {
        return EmotionNoteInteractorImplementation(dependencies)
    }
    
    class func presenter(_ dependencies: EmotionNoteDependencies, emotion: Emotion) -> EmotionNotePresenter {
        return EmotionNotePresenterImplementation(dependencies, emotion: emotion)
    }
}

struct EmotionNoteDependencies : HasEmotionNoteInteractor, HasEmotionNoteWireframe, HasJournalEntryDataStore {
    var emotionNoteWireframe: EmotionNoteWireframe!
    var emotionNoteInteractor: EmotionNoteInteractor!
    var journalEntryDataStore: JournalEntryDateStore!
}
