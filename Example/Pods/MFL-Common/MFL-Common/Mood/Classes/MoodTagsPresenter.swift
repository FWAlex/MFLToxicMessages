//
//  MoodTagsPresenter.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 04/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class MoodTagsPresenterImplementation: MoodTagsPresenter {
    
    weak var delegate : MoodTagsPresenterDelegate?
    fileprivate let interactor : MoodTagsInteractor
    fileprivate let wireframe : MoodTagsWireframe
    fileprivate let note : String?
    
    fileprivate var positiveTags = [MoodTag]()
    fileprivate var negativeTags = [MoodTag]()
    fileprivate var selectedTagIds = Set<String>()
    
    typealias Dependencies = HasMoodTagsWireframe & HasMoodTagsInteractor
    init(_ dependencies: Dependencies, emotion: Emotion, note: String?) {
        interactor = dependencies.moodTagsInteractor
        wireframe = dependencies.moodTagsWireframe
        self.emotion = emotion
        self.note = note
    }
    
    let emotion : Emotion
    
    func viewWillAppear() {
        
        delegate?.moodTagsPresenter(self, wantsToShowActivity: true)
        
        interactor.fetchMoodTags() { [weak self] result in
            
            guard let sself = self else { return }
            
            sself.delegate?.moodTagsPresenter(sself, wantsToShowActivity: false)
            
            switch result {
            case .success(let moodTags):
                sself.positiveTags = moodTags.filter { $0.isPositive }
                sself.negativeTags = moodTags.filter { !$0.isPositive }
                sself.delegate?.moodTagsPresenterWantsToReloadData(sself)
                
            case .failure(let error): sself.delegate?.moodTagsPresenter(sself, wantsToShow: error)
            }
            
        }
    }
    
    func tagCount(forPositive isPositive: Bool) -> Int {
        return isPositive ? positiveTags.count : negativeTags.count
    }
    
    func tag(at index: Int, forPositive isPositive: Bool) -> DisplayMoodTag {
        let tag = isPositive ? positiveTags[index] : negativeTags[index]
        let isSelected = selectedTagIds.contains(tag.id)
        
        return DisplayMoodTag(name: tag.name, isSelected: isSelected)
    }
    
    func userWantsToSelectTag(at index: Int, forPositive isPositive: Bool) {
        let tagId = isPositive ? positiveTags[index].id : negativeTags[index].id
        
        if selectedTagIds.contains(tagId) { selectedTagIds.remove(tagId) }
        else { selectedTagIds.insert(tagId) }
        
        delegate?.moodTagsPresenter(self, wantsToReloadAt: index, forPositive: isPositive)
    }
    
    func userWantsToSave() {
        
        MFLAnalytics.record(event: .buttonTap(name: "Tags Page Save Tapped", value: nil))
        
        delegate?.moodTagsPresenter(self, wantsToShowActivity: true)
        
        let tagIds: [String]? = selectedTagIds.count > 0 ? Array(selectedTagIds) : nil
        
        // Perform after a delay because the update happens too fast and the UI appears broken
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            
            guard let sself = self else { return }
            
            sself.interactor.submitJournalEntry(with: sself.emotion, reason: sself.note, moodTagIds: tagIds) { error in
                
                sself.delegate?.moodTagsPresenter(sself, wantsToShowActivity: false)
                
                guard error == nil else {
                    sself.delegate?.moodTagsPresenter(sself, wantsToShow: error!)
                    return
                }
                
                sself.wireframe.finish()
            }
        }
        
    }
}

