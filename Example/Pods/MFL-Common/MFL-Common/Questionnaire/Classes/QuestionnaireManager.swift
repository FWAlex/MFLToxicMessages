//
//  QuestionnaireManager.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 21/06/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

fileprivate let questionWaitTime = TimeInterval(1.0)

protocol QuestionnaireManagerDelegate : class {
    
    func questionnaireManager(_ sender: QuestionnaireManager, wantsToSetInputType inputType: QuestionInputType)
    func questionnaireManager(_ sender: QuestionnaireManager, wantsToAsk question: String, hasAnswers: Bool)
    func questionnaireManager(_ sender: QuestionnaireManager, wantsToSend answer: String)
    func questionnaireManager(_ sender: QuestionnaireManager, wantsToRespond response: String)
    func questionnaireManager(_ sender: QuestionnaireManager, wantsToCommitSendAsBulk bulk: Bool)
    func questionnaireManager(_ sender: QuestionnaireManager, wantsToSetTyping isTyping: Bool)
    func questionnaireManager(_ sender: QuestionnaireManager, didFinish questionnaire: Questionnaire)
    func questionnaireManager(_ sender: QuestionnaireManager, hasEncountered error: Error)
    func questionnaireManager(_ sender: QuestionnaireManager, wantsToShowActivity inProgress: Bool)
}

class QuestionnaireManager {
    
    weak var delegate : QuestionnaireManagerDelegate?
    
    fileprivate let dataStore : QuestionnaireDataStore
    fileprivate var questionnaire : Questionnaire!
    fileprivate var currentQuestion = 0
    
    
    typealias Dependencies = HasQuestionnaireDataStore
    init(_ dependencies: Dependencies) {
        dataStore = dependencies.questionnaireDataStore
    }
    
    func startQuestionnaire(withResponseId id: String) {
        
        if let questionnaire = dataStore.getQuestionnaire(withResponseId: id) {
           
            self.questionnaire = questionnaire
            self.start(questionnaire)
        
        } else {
            delegate?.questionnaireManager(self, hasEncountered: MFLError(title: "Questionnaire Missing", message: "No questionnaire found"))
        }
    }
    
    func startQuestionnaire(withId id: String) {
        
        delegate?.questionnaireManager(self, wantsToShowActivity: true)
        
        dataStore.fetchQuestionnaire(with: id) { [weak self] result in
            guard let sself = self else { return }
            
            sself.delegate?.questionnaireManager(sself, wantsToShowActivity: false)
            
            switch result {
            case .success(let questionnaire): sself.startQuestionnaire(withResponseId: questionnaire.responseId)
            case .failure(let error): sself.delegate?.questionnaireManager(sself, hasEncountered: error)
            }
        }
    }
    
    func start(assessment json: MFLJson) {
        
        delegate?.questionnaireManager(self, wantsToShowActivity: true)
        
        dataStore.assessment(from: json) { [unowned self] result in
            
            self.delegate?.questionnaireManager(self, wantsToShowActivity: false)
            
            switch result{
            case .success(let questionnaire): self.start(questionnaire)
            case .failure(let error): self.delegate?.questionnaireManager(self, hasEncountered: error)
            }
        }
    }
    
    func start(_ questionnaire: Questionnaire) {
        
        self.questionnaire = questionnaire
        
        currentQuestion = questionnaire.progress
        
        sendAnsweredQuestions()
        if questionnaire.isCompleted {
            submitAndContinue()
        } else {
            
            if questionnaire.progress == 0 {
                sendSumarryAndContinue()
            }
            
            else {
                sendCurrentQuestion()
            }
        }
    }
    
    private func sendSumarryAndContinue() {
        if !mfl_nilOrEmpty(questionnaire.summary) {
            delegate?.questionnaireManager(self, wantsToAsk: questionnaire.summary!, hasAnswers: false)
            delegate?.questionnaireManager(self, wantsToCommitSendAsBulk: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + questionWaitTime) { self.sendDescriptionAndContinue() }
        } else {
            sendDescriptionAndContinue()
        }
    }
    
    private func sendDescriptionAndContinue() {
        if !mfl_nilOrEmpty(questionnaire.desc) {
            delegate?.questionnaireManager(self, wantsToAsk: questionnaire.desc!, hasAnswers: false)
            delegate?.questionnaireManager(self, wantsToCommitSendAsBulk: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + questionWaitTime) { self.sendIntroductionAndContinue() }
        } else {
            sendIntroductionAndContinue()
        }
    }
    
    func sendIntroductionAndContinue() {
        if !mfl_nilOrEmpty(questionnaire.introduction) {
            delegate?.questionnaireManager(self, wantsToAsk: questionnaire.introduction!, hasAnswers: false)
            delegate?.questionnaireManager(self, wantsToCommitSendAsBulk: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + questionWaitTime) { self.sendCurrentQuestion() }
        } else {
            sendCurrentQuestion()
        }
    }
    
    func selectAnwser(at index: Int) {
        
        guard currentQuestion < questionnaire.questions.count else { return }
        
        var question = questionnaire.questions[currentQuestion]
        let option = question.options[index]
        question.answer = option.value
        
        saveAndContinue(userResponse: option.text, botResponse: option.response)
    }
    
    func anwser(with text: String) {
        
        var question = questionnaire.questions[currentQuestion]
        question.answer = text
        
        saveAndContinue(userResponse: text, botResponse: nil)
    }
    
    fileprivate func saveAndContinue(userResponse: String, botResponse: String?) {
        
        self.questionnaire.progress += 1
        
        dataStore.save(questionnaire) { [unowned self] error in
            
            guard error == nil else {
                //Revert current question
                self.questionnaire.progress = self.currentQuestion
                
                // Notify Delegate
                self.delegate?.questionnaireManager(self, hasEncountered: error!)
                
                return
            }
            
            self.delegate?.questionnaireManager(self, wantsToSend: userResponse)
            self.delegate?.questionnaireManager(self, wantsToCommitSendAsBulk: false)
            
            self.currentQuestion += 1
            
            if let response = botResponse {
                DispatchQueue.main.asyncAfter(deadline: .now() + questionWaitTime) {
                    self.delegate?.questionnaireManager(self, wantsToRespond: response)
                    self.delegate?.questionnaireManager(self, wantsToCommitSendAsBulk: false)
                    self.continueOrSubmit()
                }
            } else {
                self.continueOrSubmit()
            }
        }
    }
    
    fileprivate func continueOrSubmit() {
        
        if self.questionnaire.isCompleted {
            
            let typeName = questionnaire.type == .assessment ? "Assessment" : "Questionnaire"
            MFLAnalytics.record(event: .thresholdPassed(name: "\(typeName) Completed"))
            
            self.submitAndContinue()
        } else {
            // Short delay to make the next question feel more real.
            self.delegate?.questionnaireManager(self, wantsToSetTyping: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + questionWaitTime) {
                self.sendCurrentQuestion()
            }
        }
    }
    
    fileprivate func sendAnsweredQuestions() {
        
        if questionnaire.progress != 0 {
            if !mfl_nilOrEmpty(questionnaire.summary) { delegate?.questionnaireManager(self, wantsToAsk: questionnaire.summary!, hasAnswers: false) }
            if !mfl_nilOrEmpty(questionnaire.desc) { delegate?.questionnaireManager(self, wantsToAsk: questionnaire.desc!, hasAnswers: false) }
            if !mfl_nilOrEmpty(questionnaire.introduction) { delegate?.questionnaireManager(self, wantsToAsk: questionnaire.introduction!, hasAnswers: false) }
        }
        
        for i in 0 ..< currentQuestion {
            let question = questionnaire.questions[i]
            delegate?.questionnaireManager(self, wantsToAsk: question.text, hasAnswers: false)
            delegate?.questionnaireManager(self, wantsToSend: question.answerText ?? "")
            
            if let option = question.options.find({ $0.value == question.answer }),
                let response = option.response {
                self.delegate?.questionnaireManager(self, wantsToRespond: response)
            }
            
        }
        
        delegate?.questionnaireManager(self, wantsToCommitSendAsBulk: true)
    }
    
    fileprivate func sendCurrentQuestion() {
        
        delegate?.questionnaireManager(self, wantsToSetTyping: false)
        
        let question = questionnaire.questions[currentQuestion]
        
        if question.type == .text {
            delegate?.questionnaireManager(self, wantsToSetInputType: .text)
        } else {
            delegate?.questionnaireManager(self, wantsToSetInputType: .options(question.options.map {$0.text}))
        }
        
        delegate?.questionnaireManager(self, wantsToAsk: question.text, hasAnswers: true)
        delegate?.questionnaireManager(self, wantsToCommitSendAsBulk: false)
    }
    
    fileprivate func submitAndContinue() {
        
        dataStore.markAsComplete(questionnaire) { [unowned self] error in
            
            guard let error = error else {
                self.delegate?.questionnaireManager(self, didFinish: self.questionnaire)
                return
            }
            
            self.delegate?.questionnaireManager(self, hasEncountered: error)
        }
    }
    
}
