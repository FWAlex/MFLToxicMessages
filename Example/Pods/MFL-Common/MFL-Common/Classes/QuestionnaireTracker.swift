//
//  QuestionnaireTracker.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 02/11/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

public protocol QuestionnaireTrackerObserver : class {
    func questionnaireTrackerDidUpdateQuestionnaires(_ sender: QuestionnaireTracker)
    func questionnaireTracker(_ sender: QuestionnaireTracker, wantsToRespondeTo questionnaireResponseIds: [String])
    func questionnaireTrackerWantsToCancelQuestionniare(_ sender: QuestionnaireTracker)
}

public final class QuestionnaireTracker {
    
   public var displayMessage : String? {
        return questionnairesToComplete.count > 0 ? NSLocalizedString("Your counsellor sent you a questionnaire to complete.", comment: "") : nil
    }
    
    public var displayButton : String {
        return questionnairesHaveProgress ? NSLocalizedString("Continue", comment: "") : NSLocalizedString("Start", comment: "")
    }
    
    public var hasIncompleteQuestionnaires : Bool { return !questionnairesToComplete.isEmpty }
    fileprivate var observers = NSHashTable<AnyObject>.weakObjects()
    fileprivate var questionnairesToComplete = [Questionnaire]()
    fileprivate var questionnairesHaveProgress : Bool {
        return (self.questionnairesToComplete.reduce(0) { (result, item) in return result + item.progress} ) != 0
    }
    
    fileprivate let questionnaireDataStore: QuestionnaireDataStore
    public init(_ dependencies: HasQuestionnaireDataStore) {
        questionnaireDataStore = dependencies.questionnaireDataStore
        initialize()
    }
    
    public init(_ questionnaireDataStore: QuestionnaireDataStore) {
        self.questionnaireDataStore = questionnaireDataStore
        initialize()
    }
    
    private func initialize() {
        refreshQuestionnairesToComplete(completion: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(QuestionnaireTracker.didReceiveQuestionnaire), name: MFLDidReceiveQuestionnaire, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(QuestionnaireTracker.therapistDidCancelQuestionnaire), name: MFLTherapistDidCancelQuestionnaire, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(QuestionnaireTracker.didCompleteQuestionnaire), name: MFLDidCompleteQuestionnaire, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: MFLDidReceiveQuestionnaire, object: nil)
        NotificationCenter.default.removeObserver(self, name: MFLTherapistDidCancelQuestionnaire, object: nil)
        NotificationCenter.default.removeObserver(self, name: MFLDidCompleteQuestionnaire, object: nil)
    }
    
    @objc private func didReceiveQuestionnaire() {
        refreshQuestionnairesToComplete() { [weak self] in
            guard let sself = self else { return }
            sself.observers.questionnaireTrackerDidUpdateQuestionnaires(sself)
        }
    }
    
    @objc private func therapistDidCancelQuestionnaire() {
        refreshQuestionnairesToComplete() { [weak self] in
            guard let sself = self else { return }
            sself.observers.questionnaireTrackerWantsToCancelQuestionniare(sself)
        }
    }
    
    @objc private func didCompleteQuestionnaire() {
        refreshQuestionnairesToComplete(){ [weak self] in
            guard let sself = self else { return }
            sself.observers.questionnaireTrackerDidUpdateQuestionnaires(sself)
        }
    }
    
    private func refreshQuestionnairesToComplete(completion: (() -> Void)?) {
        questionnaireDataStore.fetchIncompleteQuestionnaires() { [unowned self] questionnaires in
            self.questionnairesToComplete = questionnaires
            completion?()
        }
    }
    
    public func startQuestionnaires() {
        MFLAnalytics.record(event: .buttonTap(name: "Start Questionnaire", value: nil))
        let questionnaireResponseIds = questionnairesToComplete.map({ $0.responseId })
        
        if questionnaireResponseIds.count >= 1 {
            observers.questionnaireTracker(self, wantsToRespondeTo: questionnaireResponseIds)
        }
    }
    
    public func add(observer: QuestionnaireTrackerObserver) {
        observers.add(observer)
    }
    
    public func remove(observer: QuestionnaireTrackerObserver) {
        observers.remove(observer)
    }
    
}

fileprivate extension NSHashTable where ObjectType == AnyObject {
    
    func questionnaireTrackerDidUpdateQuestionnaires(_ sender: QuestionnaireTracker) {
        allObjects.forEach {
            if let observer = $0 as? QuestionnaireTrackerObserver {
                observer.questionnaireTrackerDidUpdateQuestionnaires(sender)
            }
        }
    }
    
    func questionnaireTracker(_ sender: QuestionnaireTracker, wantsToRespondeTo questionnaireResponseIds: [String]) {
        allObjects.forEach {
            if let observer = $0 as? QuestionnaireTrackerObserver {
                observer.questionnaireTracker(sender, wantsToRespondeTo: questionnaireResponseIds)
            }
        }
    }
    
    func questionnaireTrackerWantsToCancelQuestionniare(_ sender: QuestionnaireTracker) {
        allObjects.forEach {
            if let observer = $0 as? QuestionnaireTrackerObserver {
                observer.questionnaireTrackerWantsToCancelQuestionniare(sender)
            }
        }
    }
}
