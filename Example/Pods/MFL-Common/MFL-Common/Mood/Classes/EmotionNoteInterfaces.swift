//
//  EmotionNoteInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 30/06/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

//MARK: - Interactor
protocol EmotionNoteInteractor {
    func submitJournalEntry(with emotion: Emotion, reason: String?, handler: @escaping (Error?) -> Void)
}

//MARK: - Presenter
protocol EmotionNotePresenterDelegate : class {
    func emotionNotePresenter(_ sender: EmotionNotePresenter, wantsToShowActivity inProgress: Bool)
    func emotionNotePresenter(_ sender: EmotionNotePresenter, wantsToPresent error: Error)
}

protocol EmotionNotePresenter {
    
    weak var delegate : EmotionNotePresenterDelegate? { get set }
    
    var emotion : Emotion { get }
    
    func userWantsToSave(with note: String?)
    func userWantsToAddTags(with note: String?)
    func userWantsToCancel()
}

//MARK: - Wireframe

protocol EmotionNoteWireframeDelegate : class {
    func emotionNoteWireframe(_ sender: EmotionNoteWireframe, wantsToPresentTagsPageWith note: String?)
    func emotionNoteWireframeDidCancel(_ sender: EmotionNoteWireframe)
    func emotionNoteWireframe(_ sender: EmotionNoteWireframe, didFinishWithSuccess success: Bool)
}

protocol EmotionNoteWireframe {
    
    weak var delegate : EmotionNoteWireframeDelegate? { get set }
    
    func start(_ dependencies: HasStoryboard & HasNavigationController & HasNetworkManager & HasMoodDataStore, emotion: Emotion)
    
    func presentTagsPage(with note: String?)
    func finish(success: Bool)
    func cancel()
}
