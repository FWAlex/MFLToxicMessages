//
//  TherapistChatInteractor.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 03/04/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class TherapistChatInteractorImplementation: TherapistChatInteractor {

    weak var delegate : TherapistChatInteractorDelegate?
    
    var user : User {
        
        let user = _userDataStore.currentUser()
        
        if user == nil {
            assertionFailure("User should be logged in at this stage.")
        }
        
        return user!
    }

    fileprivate let _userDataStore : UserDataStore
    fileprivate let _rtcManager : RTCManager
    fileprivate let _questionnaireDataStore : QuestionnaireDataStore
    
    typealias Dependencies = HasUserDataStore & HasRTCManager & HasQuestionnaireDataStore
    init(_ dependencies: Dependencies) {
        _userDataStore = dependencies.userDataStore
        _rtcManager = dependencies.rtcManager
        _questionnaireDataStore = dependencies.questionnaireDataStore
        
    }
    
    func startChat() {
        _rtcManager.add(observer: self)
    }
    
    func send(message: String) {
        _rtcManager.send(message: message)
    }
    
    func getInitialMessages() {
        _rtcManager.retrieveInitialMessages()
    }
    
    func retrievePreviousMessages() {
        return _rtcManager.retrievePreviousMessages()
    }
    
    func getIncompleteQuestionnaires(handler: ([Questionnaire]) -> Void) {
        _questionnaireDataStore.fetchIncompleteQuestionnaires(handler: handler)
    }
    
    func fetchTherapistOnlineStatus(handler: @escaping (Result<TherapistOnlineStatus>) -> Void) {
        _userDataStore.fetchTherapistOnlineStatus(handler: handler)
    }
    
    func message(at index: Int) -> Message {
        return _rtcManager.message(at: index)
    }
    
    func messagesCount() -> Int {
        return _rtcManager.messagesCount()
    }
}

//MARK: - RTCManagerObserver
extension TherapistChatInteractorImplementation : RTCManagerObserver {
    
    func rtcManager(_ sender: RTCManager, didReceive message: Message) {
        delegate?.therapistChatInteractor(self, didReceive: message)
    }
    
    func rtcManager(_ sender: RTCManager, didReceive messages: [Message]) {
        delegate?.therapistChatInteractor(self, didReceive: messages)
    }
    
    func rtcManager(_ sender: RTCManager, didReceivePrevious messages: [Message]) {
        delegate?.therapistChatInteractor(self, didReceivePrevious: messages)
    }
    
    func rtcManager(_ sender: RTCManager, didChangeStatus status: RTCConnectionStatus) {
        delegate?.therapistChatInteractor(self, didUpdateChatConnectionStatus: status == .connected)
    }
    
    func rtcManager(_ sender: RTCManager, didReceive questionnaire: Questionnaire) {
        delegate?.therapistChatInteractor(self, didReceive: questionnaire)
    }
    
    func rtcManager(_ sender: RTCManager, didDeclineQuestionnaireWith id: String) {
        delegate?.therapistChatInteractor(self, didDeclineQuestionnaireWith: id)
    }
    
}
