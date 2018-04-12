//
//  MoodTagsInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 04/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

//MARK: - Interactor
protocol MoodTagsInteractor {
    func fetchMoodTags(handler: @escaping (Result<[MoodTag]>) -> Void)
    func submitJournalEntry(with emotion: Emotion, reason: String?, moodTagIds: [String]?, handler: @escaping (Error?) -> Void)
}

//MARK: - Presenter
protocol MoodTagsPresenterDelegate : class {
    func moodTagsPresenterWantsToReloadData(_ sender: MoodTagsPresenter)
    func moodTagsPresenter(_ sender: MoodTagsPresenter, wantsToReloadAt index: Int, forPositive isPositive: Bool)
    func moodTagsPresenter(_ sender: MoodTagsPresenter, wantsToShowActivity inProgress: Bool)
    func moodTagsPresenter(_ sender: MoodTagsPresenter, wantsToShow error: Error)
}

protocol MoodTagsPresenter {
    
    weak var delegate : MoodTagsPresenterDelegate? { get set }
    
    var emotion : Emotion { get }
    func viewWillAppear()
    func tagCount(forPositive isPositive: Bool) -> Int
    func tag(at index: Int, forPositive isPositive: Bool) -> DisplayMoodTag
    func userWantsToSelectTag(at index: Int, forPositive isPositive: Bool)
    func userWantsToSave()
}

//MARK: - Wireframe

protocol MoodTagsWireframeDelegate : class {
    func moodTagsWireframeWantsToFinish(_ sender: MoodTagsWireframe)
}

protocol MoodTagsWireframe {
    
    weak var delegate : MoodTagsWireframeDelegate? { get set }
    
    func start(_ dependecies: HasNetworkManager & HasStoryboard & HasNavigationController & HasMoodDataStore,
               emotion: Emotion,
               note: String?)
    
    func finish()
}
