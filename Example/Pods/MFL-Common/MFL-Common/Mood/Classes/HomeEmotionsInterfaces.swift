//
//  HomeEmotionsInterfaces.swift
//  Pods
//
//  Created by Marc Blasi on 01/09/2017.
//
//

import UIKit

//MARK: - Interactor


public protocol HomeEmotionsInteractor {
    func hasJournalEntries(handler: @escaping (Bool) -> Void)
}

//MARK: - Presenter

public protocol HomeEmotionsPresenterDelegate : class {
    func homePresenter(_ sender: HomeEmotionsPresenter, wantsToShowHasJournalEntries hasJournalEntries: Bool)
}

public protocol HomeEmotionsPresenter {
    
    weak var delegate : HomeEmotionsPresenterDelegate? { get set }
    
    var selectedEmotion : Emotion? { get }
    
    func viewDidAppear()
    func userWantsToViewPastJournal()
    func userWantsToSelect(_ emotion: Emotion)
    func verifyHasJournalEntries()
}

//MARK: - Wireframe

public protocol HomeEmotionsWireframeDelegate : class {
    func homeWireframeWantsToPresentPastJournalPage(_ sender: HomeEmotionsWireframe)
    func homeWireframe(_ sender: HomeEmotionsWireframe, wantsToPresentEmotionPageWith emotion: Emotion, callback: ((_ succeeded: Bool) -> Void)?)
}

public protocol HomeEmotionsWireframe {
    
    weak var delegate : HomeEmotionsWireframeDelegate? { get set }
    func start(_ dependencies: HasStoryboard & HasNavigationController & HasStyle & HasNetworkManager & HasJournalEntryPersistentStore)
    
    func presentPastJournalPage()
    func presentEmotionPage(with emotion: Emotion, callback: ((_ succeeded: Bool) -> Void)?)
}
