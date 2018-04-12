//
//  QuestionnairePersistentStore.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 23/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import CoreData

class QuestionnairePersistentStoreImplementation : QuestionnairePersistentStore {
    
    fileprivate let moc : NSManagedObjectContext
    
    init(_ dependencies: HasManagedObjectContext) {
        moc = dependencies.moc
    }
    
    func newQuestionnaire(from json: MFLJson) -> Questionnaire {
        
        if let existingQuestionnaire = self.questionnaire(withResponseId: json["id"].stringValue) as? ManagedQuestionnaire {
            delete(existingQuestionnaire)
        }
        
        let managedQuestionnaire = ManagedQuestionnaire.object(from: json, moc: moc)
        managedQuestionnaire.type_ = "questionnaire"
        
        moc.saveContext()
        
        return managedQuestionnaire
    }
    
    func questionnaire(withResponseId responseId: String) -> Questionnaire? {
        
        let request = ManagedQuestionnaire.request()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(ManagedQuestionnaire.responseId_), responseId)
        
        request.predicate = predicate
        
        let questionnaires: [ManagedQuestionnaire] = moc.contextFetch(request)
        
        return questionnaires.first
    }
    
    func getIncompleteQuestionnaires() -> [Questionnaire] {
        let request = ManagedQuestionnaire.request()
        
        let predicate = NSPredicate(format: "%K == %@ AND %K == %@",
                                    #keyPath(ManagedQuestionnaire.isCompleted_), NSNumber(value: false),
                                    #keyPath(ManagedQuestionnaire.type_), "questionnaire")
        request.predicate = predicate
        
        return moc.contextFetch(request)
    }
    
    func deleteQuestionnaire(withResponseId resoinseId: String) {
        if let questionnaire = questionnaire(withResponseId: resoinseId) as? ManagedQuestionnaire {
            moc.delete(questionnaire)
            moc.saveContext()
        }
    }
    
    func newAssessment(from json: MFLJson, shouldDeleteOld: Bool) -> Questionnaire {
        if let slug = json["slug"].string,
            let assessment = assessment(for: slug) as? ManagedQuestionnaire,
            shouldDeleteOld {
            
            delete(assessment)
            moc.saveContext()
        }

        let managedAssessment = ManagedQuestionnaire.object(from: json, moc: moc)
        managedAssessment.type_ = "assessment"
        moc.saveContext()
        
        return managedAssessment
    }
    
    func assessment(from json: MFLJson) -> Questionnaire {
        if let slug = json["slug"].string, let assessment = assessment(for: slug) {
            if assessment.isCompleted {
                delete(assessment)
                moc.saveContext()
            } else {
                return assessment
            }
        }
        
        let managedAssessment = ManagedQuestionnaire.object(from: json, moc: moc)
        managedAssessment.type_ = "assessment"
        moc.saveContext()
        
        return managedAssessment
    }
    
    private func assessment(for slug: String) -> Questionnaire? {
        let fetchRequest = ManagedQuestionnaire.request()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(ManagedQuestionnaire.slug_), slug)
        fetchRequest.predicate = predicate
        
        return moc.contextFetch(fetchRequest).first
    }
    
    private func delete(_ questionnaire: Questionnaire) {
        guard let managedQuestionnaire = questionnaire as? ManagedQuestionnaire else { return }
        
        managedQuestionnaire.questions_.forEach { question in
            if let question = question as? ManagedQuestion {
                question.options_.forEach { option in
                    if let option = option as? ManagedQuestionOption { moc.delete(option) }
                }
                moc.delete(question)
            }
        }
        
        moc.delete(managedQuestionnaire)
    }
    
    func save() {
        moc.saveContext()
    }
    
    func rollback() {
        moc.rollback()
    }
}
