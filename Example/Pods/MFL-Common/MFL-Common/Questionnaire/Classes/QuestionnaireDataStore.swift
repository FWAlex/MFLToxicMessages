//
//  QuestionnaireDataStore.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 23/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class QuestionnaireDataStoreImplementation : QuestionnaireDataStore {
    
    fileprivate let networkManager : NetworkManager
    fileprivate let persistentStore : QuestionnairePersistentStore
    
    typealias Dependencies = HasNetworkManager & HasQuestionnairePersistentStore
    init(_ dependencies: Dependencies) {
        persistentStore = dependencies.questionnairePersistentStore
        networkManager = dependencies.networkManager
    }
    
    func questionnaire(from json: MFLJson) -> Questionnaire {
        return persistentStore.newQuestionnaire(from: json)
    }
    
    func getQuestionnaire(withResponseId responseId: String) -> Questionnaire? {
        return persistentStore.questionnaire(withResponseId: responseId)
    }
    
    func fetchQuestionnaire(with id: String, handler: @escaping (Result<Questionnaire>) -> Void) {
        networkManager.fetchQuestionnaire(with: id) { [unowned self] result in
            switch result {
            case .success(let json): handler(.success(self.persistentStore.newQuestionnaire(from: json["content"])))
            case .failure(let error): handler(.failure(error))
            }
        }
        
    }
    
    func markAsComplete(_ questionnaire: Questionnaire, handler: @escaping (Error?) -> Void) {
        
        if questionnaire.type == .assessment {
            handler(nil)
            return
        }
        
        networkManager.markAsComplete(questionnaire: questionnaire) {
            switch $0 {
            case .success(_): handler(nil)
            case .failure(let error): handler(error)
            }
        }
    }
    
    func save(_ questionnaire: Questionnaire, handler: @escaping (Error?) -> Void) {
        
        if questionnaire.type == .assessment {
            do {
                try networkManager.update(assessment: questionnaire) { [weak self] result in
                    self?.handleSaveResponse(result, handler: handler)
                }
            } catch {
                handler(MFLError(title: "Something went wrong", message: "Please try again later") )
            }
        } else {
            networkManager.update(questionnaire: questionnaire) { [weak self] result in
                self?.handleSaveResponse(result, handler: handler)
            }
        }
    }
    
    fileprivate func handleSaveResponse(_ result: Result<MFLJson>, handler: @escaping (Error?) -> Void) {
        switch result {
        case .success(_):
            persistentStore.save()
            handler(nil)
        case .failure(let error): handler(error)
        }
    }
    
    func fetchIncompleteQuestionnaires(handler: ([Questionnaire]) -> Void) {
        handler(self.persistentStore.getIncompleteQuestionnaires())
    }
    
    func deleteQuestionnaire(withResponseId responseId: String) {
        persistentStore.deleteQuestionnaire(withResponseId: responseId)
    }
    
    func rollback() {
        persistentStore.rollback()
    }
    
    func assessment(from json: MFLJson, handler: @escaping (Result<Questionnaire>) -> Void) {
        
        networkManager.getLatestIncompleteAssessment(with: json["slug"].string!) { [unowned self] result in
            switch result {
            
            case .success(let incompleteAssessmentJson):
            
                if incompleteAssessmentJson["content"]["results"].arrayValue.count > 0 { // We have an incomplete assessmentDependencies
                    let assessment = self.persistentStore.newAssessment(from: incompleteAssessmentJson["content"]["results"].arrayValue[0], shouldDeleteOld: true)
                    handler(.success(assessment))
                } else {
                    let assessment = self.persistentStore.assessment(from: json)
                    if mfl_nilOrEmpty(assessment.id) {
                        self.networkManager.getId(for: assessment) { [unowned self] result in
                            switch result {
                            case .success(let json): handler(.success(self.persistentStore.newAssessment(from: json["content"], shouldDeleteOld: true)))
                            case .failure(let error): handler(.failure(error))
                            }
                        }
                    } else {
                        handler(.success(assessment))
                    }
                }
                
            case .failure(let error) :
                
                handler(.failure(error))
            }
        }
        
        
    }
}
