//
//  QuestionnaireDataStoreInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 23/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

public protocol QuestionnaireDataStore {
    func questionnaire(from json: MFLJson) -> Questionnaire
    func getQuestionnaire(withResponseId responseId: String) -> Questionnaire?
    func fetchQuestionnaire(with id: String, handler: @escaping (Result<Questionnaire>) -> Void)
    func markAsComplete(_ questionnaire: Questionnaire, handler: @escaping (Error?) -> Void)
    func fetchIncompleteQuestionnaires(handler: ([Questionnaire]) -> Void)
    func save(_ questionnaire: Questionnaire, handler: @escaping (Error?) -> Void)
    func deleteQuestionnaire(withResponseId responseId: String)
    func rollback()
    func assessment(from json: MFLJson, handler: @escaping (Result<Questionnaire>) -> Void)
}

protocol QuestionnairePersistentStore {
    func newQuestionnaire(from json: MFLJson) -> Questionnaire
    func questionnaire(withResponseId responseId: String) -> Questionnaire?
    func getIncompleteQuestionnaires() -> [Questionnaire]
    func deleteQuestionnaire(withResponseId responseId: String)
    
    /**
     *  Returns a new questionnaire from the provided JSON.
     *  If a questionnaire with the same slug exists, that will be returned.
     *  Else a new one will be created.
     */
    func assessment(from json: MFLJson) -> Questionnaire
    
    /**
     *  Creates a new questionnaire from the provided JSON.
     *  If shouldDeleteOld is true then the saved questionnaire that has the same slug
     *  will be deleted.
     */
    func newAssessment(from json: MFLJson, shouldDeleteOld: Bool) -> Questionnaire
    func save()
    func rollback()
}

