//
//  HomeEmotionsPresenter.swift
//  Pods
//
//  Created by Marc Blasi on 01/09/2017.
//
//

import Foundation

class HomeEmotionsPresenterImplementation: HomeEmotionsPresenter {
    weak var delegate : HomeEmotionsPresenterDelegate?
    fileprivate let interactor: HomeEmotionsInteractor
    fileprivate let wireframe: HomeEmotionsWireframe
    var selectedEmotion : Emotion?
    
    typealias Dependencies = HasHomeEmotionsWireframe & HasHomeEmotionsInteractor
    init(_ dependencies: Dependencies) {
        interactor = dependencies.HomeEmotionsInteractor
        wireframe = dependencies.HomeEmotionsWireframe
    }
    
    func userWantsToViewPastJournal() {
        wireframe.presentPastJournalPage()
    }
    
    func userWantsToSelect(_ emotion: Emotion) {
        wireframe.presentEmotionPage(with: emotion) {[weak self] (succeeded) in
            if succeeded { self?.selectedEmotion = emotion }
        }
    }
    
    func viewDidAppear() {
        selectedEmotion = nil
    }
    
    func verifyHasJournalEntries() {
        
        interactor.hasJournalEntries() { [weak self] hasJournalEntries in
            guard let sself = self else { return }
            sself.delegate?.homePresenter(sself, wantsToShowHasJournalEntries: hasJournalEntries)
        }
    }
}
