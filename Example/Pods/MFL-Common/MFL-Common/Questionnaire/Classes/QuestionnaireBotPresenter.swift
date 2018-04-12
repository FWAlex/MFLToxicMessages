//
//  QuestionnaireBotPresenter.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 23/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class QuestionnaireBotPresenterImplementation: QuestionnaireBotPresenter {
    
    weak var delegate : QuestionnaireBotPresenterDelegate?
    
    fileprivate let wireframe : QuestionnaireBotWireframe
    fileprivate let questionnaireManager : QuestionnaireManager
    fileprivate var currentQuestionnaireIndex = 0
    fileprivate let endMessage : String?
    fileprivate let endWait : TimeInterval
    fileprivate let questionnaireIds : [QuestionnaireBotIdType]
    fileprivate let shouldAutomaticallyClose : Bool
    
    typealias Dependencies = HasQuestionnaireManager & HasQuestionnaireBotWireframe
    init(_ dependencies: Dependencies, questionnaireIds: [QuestionnaireBotIdType], endMessage: String?, endWait: TimeInterval, shouldAutomaticallyClose: Bool) {
        questionnaireManager = dependencies.questionnaireManager
        wireframe = dependencies.questionnaireBotWireframe
        self.endMessage = endMessage
        self.endWait = endWait
        self.questionnaireIds = questionnaireIds
        self.shouldAutomaticallyClose = shouldAutomaticallyClose

        questionnaireManager.delegate = self
    }
    
    func viewDidAppear() {
        
        guard questionnaireIds.count > currentQuestionnaireIndex else {
            self.wireframe.finish()
            return
        }
        
        questionnaireManager.startQuestionnaire(with: questionnaireIds[currentQuestionnaireIndex])
    }
    
    func userSelectedAnwser(at index: Int) {
        questionnaireManager.selectAnwser(at: index)
    }
    
    func userWantsToAnwser(text: String) {
        questionnaireManager.anwser(with: text)
    }
    
    func userWantsToCancel() {
        MFLAnalytics.record(event: .buttonTap(name: "Bot Screen Close Tapped", value: nil))
        wireframe.finish()
    }
}

extension QuestionnaireBotPresenterImplementation : QuestionnaireManagerDelegate {
    
    func questionnaireManager(_ sender: QuestionnaireManager, wantsToSetInputType inputType: QuestionInputType) {
        delegate?.questionnaireBotPresenter(self, wantsToSetInputType: inputType)
    }
    
    func questionnaireManager(_ sender: QuestionnaireManager, wantsToAsk question: String, hasAnswers: Bool) {
        delegate?.questionnaireBotPresenter(self, wantsToAsk: question, hasAnswers: hasAnswers)
    }
    
    func questionnaireManager(_ sender: QuestionnaireManager, wantsToSend answer: String) {
        delegate?.questionnaireBotPresenter(self, wantsToSend: answer)
    }
    
    func questionnaireManager(_ sender: QuestionnaireManager, wantsToRespond response: String) {
        delegate?.questionnaireBotPresenter(self, wantsToRespond: response)
    }
    
    func questionnaireManager(_ sender: QuestionnaireManager, wantsToCommitSendAsBulk bulk: Bool) {
        delegate?.questionnaireBotPresenter(self, wantsToCommitSend: !bulk)
    }
    
    func questionnaireManager(_ sender: QuestionnaireManager, wantsToSetTyping isTyping: Bool) {
        /* Empty */
    }
    
    func questionnaireManager(_ sender: QuestionnaireManager, didFinish questionnaire: Questionnaire) {
        
        currentQuestionnaireIndex += 1
        
        guard questionnaireIds.count > currentQuestionnaireIndex else {
            
            var endMessageTime = TimeInterval(0.0)
            
            if let endMessage = endMessage {
                
                // Short delay to seem natural
                endMessageTime = 0.5
                DispatchQueue.main.asyncAfter(deadline: .now() + endMessageTime) { [unowned self] in
                    self.delegate?.questionnaireBotPresenter(self, wantsToRespond: endMessage)
                    self.delegate?.questionnaireBotPresenter(self, wantsToCommitSend: true)
                }
            }
            
            if endWait > 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + endMessageTime) { [unowned self] in
                    self.delegate?.questionnaireBotPresenter(self, wantsToDisplayLoading: true)
                }
            }
        
            DispatchQueue.main.asyncAfter(deadline: .now() + endWait + endMessageTime) { [unowned self] in
                if self.endWait > 0 { self.delegate?.questionnaireBotPresenter(self, wantsToDisplayLoading: false) }
                
                if self.shouldAutomaticallyClose {
                    self.wireframe.finish()
                } else {
                    self.delegate?.questionnaireBotPresenter(self, wantsToAllowUserToClose: true)
                }
            }
        
            return
        }
        
        // Short delay to seem natural
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
            self.questionnaireManager.startQuestionnaire(with: self.questionnaireIds[self.currentQuestionnaireIndex])
        }
    }
    
    func questionnaireManager(_ sender: QuestionnaireManager, hasEncountered error: Error) {
        delegate?.questionnaireBotPresenter(self, wantsToDisplay: error)
    }
    
    func questionnaireManager(_ sender: QuestionnaireManager, wantsToShowActivity inProgress: Bool) {
        delegate?.questionnaireBotPresenter(self, wantsToDisplayLoading: inProgress)
    }
}

//MARK: - Helper
fileprivate extension QuestionnaireManager {
   
    func startQuestionnaire(with idType: QuestionnaireBotIdType) {
        switch idType {
        case .id(let id): self.startQuestionnaire(withId: id)
        case .responseId(let id): self.startQuestionnaire(withResponseId: id)
        case .assessment(let json): self.start(assessment: json)
        }
    }
}







