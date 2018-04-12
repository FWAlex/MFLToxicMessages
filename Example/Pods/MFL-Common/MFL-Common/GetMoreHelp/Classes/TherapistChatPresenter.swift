//
//  TherapistChatPresenter.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 03/04/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

fileprivate enum TherapistChatState : Int, Priority {

    case noSessionTokens = 0
    case someSessionTokens = 1
    case sessionNow = 2
    case incompleteQuestionnaires = 3
    case invalidSubscription = 4
    
    var priority : Int {
        return self.rawValue
    }
}

class TherapistChatPresenterImplementation: TherapistChatPresenter {
    
    weak var delegate : TherapistChatPresenterDelegate?
    
    fileprivate let interactor : TherapistChatInteractor
    fileprivate let wireframe : TherapistChatWireframe
    fileprivate var questionnairesToComplete : [Questionnaire]?
    fileprivate var states = States<TherapistChatState>()
    fileprivate var didShowOOOAlert = false
    fileprivate var teamMembers = [TeamMember]()
    fileprivate var questionnairesHaveProgress : Bool {
        return (self.questionnairesToComplete?.reduce(0) { (result, item) in return result + item.progress} ?? 0) != 0
    }
    fileprivate var didSendMessageAnalytics = false
    
    typealias Dependencies = HasTherapistChatWireframe & HasTherapistChatInteractor
    
    init(_ dependencies: Dependencies) {
        interactor = dependencies.therapistChatInteractor
        wireframe = dependencies.therapistChatWireframe
    }
    
    func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(didFetchSessions), name: MFLDidFetchSessionsNotification, object: nil)
        interactor.startChat()
    }

    func viewDidAppear() {
        refreshSubscriptionStatus()
        refreshQuestionnairesToComplete()
        refreshSessionsState()
        refreshSessionsTokenState()
        updateViewState()
    }
    
    var messageCount: Int {
        return interactor.messagesCount()
    }
    
    func message(at index: Int) -> MFLMessage {
        let message = interactor.message(at: index)
        return MFLMessage(message, isOutgoing: isOutgoing(message))
    }
    
    func userWantsToSend(_ message: String) {
        interactor.send(message: message)
        if didSendMessageAnalytics {
            MFLAnalytics.record(event: .thresholdPassed(name: "Get More Help Tool Used"))
        }
    }
    
    var assignedTeamMemberName: String {
        return interactor.user.assignedTeamMember.name
    }
    
    var assignedTeamMemberAvatarURL: URL? {
        return URL(string: interactor.user.assignedTeamMember.avatarURL)
    }
    
    func userWantsToSeeTherapistDetails() {
        wireframe.presentDetailsFor(interactor.user.assignedTeamMember)
    }
    
    func userWantsToSeeTheTeam() {
        wireframe.presentTeamOverviewPage()
    }
    
    func retrievePreviousMessages() {
        interactor.retrievePreviousMessages()
    }
    
    func userWantsToSeeVideoOptions() {
        MFLAnalytics.record(event: .buttonTap(name: "Purchase Video Sessions Tapped", value: nil))
        wireframe.presentBuyBoltonsPage()
    }
}

//MARK: - Helper
fileprivate extension TherapistChatPresenterImplementation {
    
    @objc func didFetchSessions() {
        refreshSessionsState()
        updateViewState()
    }
    
    func refreshSessionsTokenState() {
        states.remove(.someSessionTokens)
        states.remove(.noSessionTokens)
        if let tokensCount = interactor.user.userPackage?.tokensCount,
            tokensCount > 0 {
            states.add(.someSessionTokens)
        } else {
            states.add(.noSessionTokens)
        }
    }
    
    func refreshSessionsState() {
        states.remove(.sessionNow)
        
        guard let upcomingSessions = upcomingSessions(),
            let firstUpcomingSession = upcomingSessions.first else {
            return
        }
        
        if isNow(firstUpcomingSession) {
            states.add(.sessionNow)
        }
    }
    
    func upcomingSessions() -> [Session]? {
        
        let now = Date()
        let upcomingSessions = interactor.user.sessions?.filter { $0.endDate > now }
        let sortedSessions = upcomingSessions?.sorted { $0.startDate < $1.startDate }
        
        return sortedSessions
    }
    
    func isNow(_ session: Session) -> Bool {
        let now = Date()
        return session.startDate < now && session.endDate > now
    }
    
    func isOutgoing(_ message: Message) -> Bool {
        return message.senderId == interactor.user.id
    }
    
    func refreshQuestionnairesToComplete() {
        interactor.getIncompleteQuestionnaires() { [unowned self] questionnaires in
            self.questionnairesToComplete = questionnaires
            if questionnaires.count >= 1 { self.states.add(.incompleteQuestionnaires) }
            else {
                self.states.remove(.incompleteQuestionnaires)
            }
            self.updateViewState()
        }
    }
    
    func refreshSubscriptionStatus() {
        if !mfl_isValid(interactor.user.userPackage) {
            states.add(.invalidSubscription)
            delegate?.therapistChatPresenter(self, wantsToSetInputViewHidden: true)
        }
        else {
            states.remove(.invalidSubscription)
            delegate?.therapistChatPresenter(self, wantsToSetInputViewHidden: false)
        }
    
        updateViewState()
    }
    
    func updateViewState() {
        
        guard let state = states.topPriority else {
            delegate?.therapistPresenter(self, wantsToShowInfo: nil, image: nil, isDismissable: true, button: nil, action: nil)
            return
        }
        
        switch state {
        case .sessionNow:
            if let session = upcomingSessions()?.first {
                let buttonTitle = NSLocalizedString("Join", comment: "")
                let text1 = NSLocalizedString("Session with", comment: "")
                let text2 = NSLocalizedString("happening now.", comment: "")
                let image = UIImage(named: "get_more_help_banner_session_now", bundle: MFLCommon.shared.appBundle)
                delegate?.therapistPresenter(self, wantsToShowInfo: text1 + " \(session.teamMemberFirstName) " + text2, image: image, isDismissable: false, button: buttonTitle) {
                    [weak self] in
                    MFLAnalytics.record(event: .buttonTap(name: "Join Video Chat Tapped", value: nil))
                    self?.wireframe.presentVideoPage(with: session)
                }
            }
            
        case .someSessionTokens:
            if let tokensNo = interactor.user.userPackage?.tokensCount {
                let text1 = NSLocalizedString("You have", comment: "")
                let text2 = NSLocalizedString("Video", comment: "") + " " +
                    ( tokensNo == 1 ? NSLocalizedString("Session", comment: "") : NSLocalizedString("Sessions", comment: "")) + "\n" +
                    NSLocalizedString("Message the team to schedule ", comment: "")
                let image = UIImage(named: "get_more_help_banner_session_now", bundle: MFLCommon.shared.appBundle)
                
                delegate?.therapistPresenter(self, wantsToShowInfo: "\(text1) \(tokensNo) \(text2)", image: image, isDismissable: true, button: nil, action: nil)
            }
            
        case .noSessionTokens:
            let buttonTitle = NSLocalizedString("Purchase Video Sessions", comment: "")
            let image = UIImage(named: "get_more_help_banner_session_now", bundle: MFLCommon.shared.appBundle)
            delegate?.therapistPresenter(self, wantsToShowInfo: NSLocalizedString("Would you prefer a face to face chat?", comment: ""), image: image, isDismissable: true, button: buttonTitle) {
                [weak self] in
                self?.wireframe.presentBuyBoltonsPage()
            }
            
        case .incompleteQuestionnaires:
            let buttonTitle = questionnairesHaveProgress ? NSLocalizedString("Continue", comment: "") : NSLocalizedString("Start", comment: "")
            delegate?.therapistPresenter(self, wantsToShowInfo: NSLocalizedString("Please complete this questionnaire.\nThis will help us help you", comment: ""), image: nil, isDismissable: false,
                                         button: buttonTitle) { [weak self] in self?.userWantsToCompleteQuestionnaire() }
        
        case .invalidSubscription:
             break
//            let text = NSLocalizedString("Your subscription has expired.\nPlease renew your subscription to keep counselling with ", comment: "") + assignedTeamMemberName + "."
//            delegate?.therapistPresenter(self, wantsToShowInfo: text, image: nil,
//                                         button: NSLocalizedString("Renew", comment: "")) { [weak self] in self?.userWantsToRenewSubscription() }
        }
    }
    
    func userWantsToCompleteQuestionnaire() {
        if let questionnaires = questionnairesToComplete{
            let questionnaireResponseIds = questionnaires.map({ QuestionnaireBotIdType.responseId($0.responseId) })
            
            if questionnaireResponseIds.count >= 1 {
                wireframe.presentQuestionnairePage(for: questionnaireResponseIds)
            }
        }
    }
    
    func userWantsToRenewSubscription() {
//        wireframe.presentPaymentPage()
    }
}

//MARK: - TherapistChatInteractorDelegate
extension TherapistChatPresenterImplementation : TherapistChatInteractorDelegate {
    
    func therapistChatInteractor(_ sender: TherapistChatInteractor, didReceive message: Message) {
        delegate?.therapistChatPresenterDidReceiveNewMessage(self, outgoing: isOutgoing(message))
    }
  
    func therapistChatInteractor(_ sender: TherapistChatInteractor, didReceive messages: [Message]) {
        delegate?.therapistChatPresenterDidReceiveNewMessage(self, count: messages.count, animated: false)
    }
    
    func therapistChatInteractor(_ sender: TherapistChatInteractor, didReceivePrevious messages: [Message]) {
        delegate?.therapistChatPresenterDidRetrievePreviousMessages(self, count: messages.count)
    }
    
    func therapistChatInteractor(_ sender: TherapistChatInteractor, didUpdateChatConnectionStatus connected: Bool) {
        delegate?.therapistChatPresenter(self, didUpdateChatConnectedStatus: connected)
    }
    
    func therapistChatInteractor(_ sender: TherapistChatInteractor, didReceive questionnaire: Questionnaire) {
        
        let message = assignedTeamMemberName + NSLocalizedString(" has sent you a new questionnaire to complete. ", comment: "")
        
        wireframe.closeQuestionnairePage(message: message)
        refreshQuestionnairesToComplete()
    }
    
    func therapistChatInteractor(_ sender: TherapistChatInteractor, didDeclineQuestionnaireWith id: String) {
        let message = assignedTeamMemberName + NSLocalizedString(" has declined this questionnaire. ", comment: "")
        
        wireframe.closeQuestionnairePage(message: message)
        refreshQuestionnairesToComplete()
    }
}

fileprivate extension MFLMessage {
    
    init(_ message: Message, isOutgoing: Bool) {
        text = message.text
        senderName = isOutgoing ? NSLocalizedString("Me", comment: "") : message.senderName
        senderPlaceholder = message.senderName
        senderImageURL = message.imageUrlString
        self.isOutgoing = isOutgoing
    }
}
