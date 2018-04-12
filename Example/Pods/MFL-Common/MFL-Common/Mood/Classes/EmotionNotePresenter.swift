//
//  EmotionNotePresenter.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 30/06/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class EmotionNotePresenterImplementation: EmotionNotePresenter {
    
    weak var delegate : EmotionNotePresenterDelegate?
    fileprivate let interactor: EmotionNoteInteractor
    fileprivate let wireframe: EmotionNoteWireframe
    
    let emotion : Emotion
    
    typealias Dependencies = HasEmotionNoteWireframe & HasEmotionNoteInteractor
    init(_ dependencies: Dependencies, emotion: Emotion) {
        interactor = dependencies.emotionNoteInteractor
        wireframe = dependencies.emotionNoteWireframe
        self.emotion = emotion
    }
    
    func userWantsToSave(with note: String?) {
        
        MFLAnalytics.record(event: .buttonTap(name: "Emotion Detail Page Save Tapped", value: nil))
        
        delegate?.emotionNotePresenter(self, wantsToShowActivity: true)
        
        //Short delay because the save is happening to fast and the UI seems broken
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    
            self.interactor.submitJournalEntry(with: self.emotion, reason: note) { [unowned self] error in
                
                self.delegate?.emotionNotePresenter(self, wantsToShowActivity: false)
                
                if let error = error {
                    self.delegate?.emotionNotePresenter(self, wantsToPresent: error)
                    return
                }
                
                self.wireframe.finish(success: true)
            }
        }
    }
    
    func userWantsToAddTags(with note: String?) {
        MFLAnalytics.record(event: .buttonTap(name: "Emotion Detail Page Add Tag Tapped", value: nil))
        wireframe.presentTagsPage(with: note)
    }
    
    func userWantsToCancel() {
        wireframe.cancel()
    }
}
