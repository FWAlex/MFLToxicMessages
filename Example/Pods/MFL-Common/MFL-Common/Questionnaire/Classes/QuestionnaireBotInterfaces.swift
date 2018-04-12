//
//  QuestionnaireBotInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 23/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

//MARK: - Interactor

protocol QuestionnaireBotInteractor {
    func fetchQuestionnaire(with id: String, handler: @escaping (QuestionnaireBotResult) -> Void)
    func submit(questionnaire: Questionnaire, handler: @escaping (Error?) -> Void)
    func save(questionnaire: Questionnaire)
    func rollback()
}

//MARK: - Presenter

protocol QuestionnaireBotPresenterDelegate : class {
    func questionnaireBotPresenter(_ sender: QuestionnaireBotPresenter, wantsToSetInputType inputType: QuestionInputType)
    func questionnaireBotPresenter(_ sender: QuestionnaireBotPresenter, wantsToAsk question: String, hasAnswers: Bool)
    func questionnaireBotPresenter(_ sender: QuestionnaireBotPresenter, wantsToSend answer: String)
    func questionnaireBotPresenter(_ sender: QuestionnaireBotPresenter, wantsToRespond response: String)
    func questionnaireBotPresenter(_ sender: QuestionnaireBotPresenter, wantsToCommitSend animated: Bool)
    func questionnaireBotPresenter(_ sender: QuestionnaireBotPresenter, wantsToDisplay error: Error)
    func questionnaireBotPresenter(_ sender: QuestionnaireBotPresenter, wantsToAllowUserToClose shouldAllowClose: Bool)
    
    func questionnaireBotPresenter(_ sender: QuestionnaireBotPresenter, wantsToDisplayLoading isLoading: Bool)
}

protocol QuestionnaireBotPresenter {
    
    weak var delegate : QuestionnaireBotPresenterDelegate? { get set }
    
    func viewDidAppear()
    func userSelectedAnwser(at index: Int)
    func userWantsToAnwser(text: String)
    func userWantsToCancel()
}

//MARK: - Wireframe

public protocol QuestionnaireBotWireframeDelegate : class {
    func questionnaireBotWireframeDidFinish(_ sender: QuestionnaireBotWireframe)
}

public enum QuestionnaireBotIdType {
    case id(String)
    case responseId(String)
    case assessment(json: MFLJson)
}

public protocol QuestionnaireBotWireframe {
    
    weak var delegate : QuestionnaireBotWireframeDelegate? { get set }
    
    func start(_ dependencies: HasNetworkManager & HasNavigationController & HasStyle,
               questionnaireIds: [QuestionnaireBotIdType],
               endMessage: String?,
               endWait: TimeInterval,
               title: String?)
    
    func start(_ dependencies: HasNetworkManager & HasNavigationController & HasStyle,
               questionnaireIds: [QuestionnaireBotIdType],
               endMessage: String?,
               endWait: TimeInterval,
               allowUserToClose: Bool,
               shouldAutomaticallyClose: Bool,
               title: String?)
    
    func finish()
}
