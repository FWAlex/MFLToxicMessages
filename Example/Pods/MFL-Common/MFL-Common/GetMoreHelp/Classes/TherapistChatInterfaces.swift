//
//  TherapistChatInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 03/04/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

//MARK: - Interactor

protocol TherapistChatInteractorDelegate : class {
    func therapistChatInteractor(_ sender: TherapistChatInteractor, didReceive message: Message)
    func therapistChatInteractor(_ sender: TherapistChatInteractor, didReceive messages: [Message])
    func therapistChatInteractor(_ sender: TherapistChatInteractor, didReceivePrevious messages: [Message])
    func therapistChatInteractor(_ sender: TherapistChatInteractor, didUpdateChatConnectionStatus connected: Bool)
    func therapistChatInteractor(_ sender: TherapistChatInteractor, didReceive questionnaire: Questionnaire)
    func therapistChatInteractor(_ sender: TherapistChatInteractor, didDeclineQuestionnaireWith id: String)
}

protocol TherapistChatInteractor {
    
    weak var delegate : TherapistChatInteractorDelegate? { get set }
    
    var user : User { get }
    func send(message: String)
    func getInitialMessages()
    func retrievePreviousMessages()
    func getIncompleteQuestionnaires(handler: ([Questionnaire]) -> Void)
    func fetchTherapistOnlineStatus(handler: @escaping (Result<TherapistOnlineStatus>) -> Void)
    func message(at index: Int) -> Message
    func messagesCount() -> Int
    func startChat()
    
}

//MARK: - Presenter

protocol TherapistChatPresenterDelegate : class {
    func therapistChatPresenterDidReceiveNewMessage(_ sender: TherapistChatPresenter, outgoing isOutgoing: Bool)
    func therapistChatPresenterDidReceiveNewMessage(_ sender: TherapistChatPresenter, count: Int, animated: Bool)
    func therapistChatPresenterDidRetrievePreviousMessages(_ sender: TherapistChatPresenter, count: Int)
    func therapistChatPresenter(_ sender: TherapistChatPresenter, didUpdateChatConnectedStatus connected: Bool)
    func therapistChatPresenter(_ sender: TherapistChatPresenter, wantsToSetInputViewHidden isHidden: Bool)
    
    func therapistPresenter(_ sender: TherapistChatPresenter,
                            wantsToShowInfo text: String?,
                            image: UIImage?,
                            isDismissable: Bool,
                            button: String?,
                            action: (() -> Void)?)
}

protocol TherapistChatPresenter {
    
    weak var delegate : TherapistChatPresenterDelegate? { get set }
    
    func viewDidLoad()
    func viewDidAppear()
    
    var messageCount : Int { get }
    func message(at index: Int) -> MFLMessage
    
    var assignedTeamMemberName : String { get }
    var assignedTeamMemberAvatarURL : URL? { get }
    
    func userWantsToSend(_ message: String)
    func userWantsToSeeTherapistDetails()
    func userWantsToSeeTheTeam()
    func retrievePreviousMessages()
    func userWantsToSeeVideoOptions()
}

//MARK: - Wireframe

protocol TherapistChatWireframeDelegate : class {
  
    func therapistChatWireframe(_ sender: TherapistChatWireframe,
                                wantsToPresentDetailsFor assignedTeamMember: TeamMember)
    func therapistChatWireframeWantsToPresentTeamOverviewPage(_ sender: TherapistChatWireframe)
    func therapistChatWireframe(_ sender: TherapistChatWireframe, wantsToPresentQuestionnairePageWith questionnaireIds: [QuestionnaireBotIdType])
    func therapistChatWireframe(_ sender: TherapistChatWireframe, wantsToCloseQuestionnairePageWith message: String)
    func therapistChatWireframeWantsToPresentBuyBoltonsPage(_ sender: TherapistChatWireframe)
    func therapistChatWireframe(_ sender: TherapistChatWireframe, wantsToPresentVideoPageWith session: Session)
}

protocol TherapistChatWireframe {
    
    weak var delegate : TherapistChatWireframeDelegate? { get set }
    
    func start(_ dependencies: HasNavigationController & HasNetworkManager & HasUserDataStore & HasStyle & HasRTCManager)
    
    func presentDetailsFor(_ assignedTeamMember: TeamMember)
    func presentTeamOverviewPage()
    func presentQuestionnairePage(for questionnaireIds: [QuestionnaireBotIdType])
    func closeQuestionnairePage(message: String)
    func presentBuyBoltonsPage()
    func presentVideoPage(with session: Session)
}
