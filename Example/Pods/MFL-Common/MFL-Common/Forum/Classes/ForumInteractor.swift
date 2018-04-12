//
//  ForumInteractor.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 10/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class ForumInteractorImplementation: ForumInteractor {
    
    var presenter: ForumPresenter!
    fileprivate var questionnaireTracker: QuestionnaireTracker
    
    typealias Dependencies = HasQuestionnaireTracker
    
    init(_ dependencies: Dependencies) {
        self.questionnaireTracker = dependencies.questionnaireTracker
        self.questionnaireTracker.add(observer: self)
    }
    
    func userWantsToStartQuestionary() {
        self.questionnaireTracker.startQuestionnaires()
    }
}

extension ForumInteractorImplementation: QuestionnaireTrackerObserver {
    func questionnaireTrackerDidUpdateQuestionnaires(_ sender: QuestionnaireTracker) {
        self.presenter.updateQuestionnaireInfo(message: sender.displayMessage, buttonText: sender.displayButton)
    }
    
    
    func questionnaireTrackerWantsToCancelQuestionniare(_ sender: QuestionnaireTracker) {
        self.presenter.updateQuestionnaireInfo(message: sender.displayMessage, buttonText: sender.displayButton)
    }
    
    func questionnaireTracker(_ sender: QuestionnaireTracker, wantsToRespondeTo questionnaireResponseIds: [String]) {}
    
}
