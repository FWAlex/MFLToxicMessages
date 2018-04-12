//
//  ToolsInteractor.swift
//  MFLRecovery
//
//  Created by Marc Blasi on 11/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class ToolsInteractorImplementation: ToolsInteractor {
    
    var presenter: ToolsPresenter!

    fileprivate let userDataStore : UserDataStore
    fileprivate var questionnaireTracker: QuestionnaireTracker
    
    typealias Dependencies = HasUserDataStore & HasQuestionnaireTracker
    
    init(_ dependencies: Dependencies) {
        userDataStore = dependencies.userDataStore
        self.questionnaireTracker = dependencies.questionnaireTracker
        self.questionnaireTracker.add(observer: self)
    }
    
    func user() -> User {
        return userDataStore.currentUser()!
    }
    
    func userWantsToStartQuestionary() {
        self.questionnaireTracker.startQuestionnaires()
    }
}

extension ToolsInteractorImplementation: QuestionnaireTrackerObserver {
    func questionnaireTrackerDidUpdateQuestionnaires(_ sender: QuestionnaireTracker) {
        self.presenter.updateQuestionnaireInfo(message: sender.displayMessage, buttonText: sender.displayButton)
    }
    
    
    func questionnaireTrackerWantsToCancelQuestionniare(_ sender: QuestionnaireTracker) {
        self.presenter.updateQuestionnaireInfo(message: sender.displayMessage, buttonText: sender.displayButton)
    }
    
    func questionnaireTracker(_ sender: QuestionnaireTracker, wantsToRespondeTo questionnaireResponseIds: [String]) {}

}
