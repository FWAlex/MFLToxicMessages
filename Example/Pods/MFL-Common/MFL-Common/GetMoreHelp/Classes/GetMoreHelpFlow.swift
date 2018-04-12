//
//  TherapistChatFlow.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 07/04/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

public class GetMoreHelpFlow {
    
    fileprivate var dependencies = GetMoreHelpFlowFlowDependencies()
    
    fileprivate var questionnaireBotWireframe : QuestionnaireBotWireframe?
    fileprivate var sessionsManager : SessionsManager!
    fileprivate var paymentFlow : PaymentFlow?
    
    public init() { /* Empty */ }
    
    public func start(_ dependencies: HasNavigationController & HasNetworkManager & HasUserDataStore & HasStyle & HasPackageDataStore & HasBoltonDataStore & HasVideoChatProvider & HasRTCManager) {
        self.dependencies.navigationController = dependencies.navigationController
        self.dependencies.networkManager = dependencies.networkManager
        self.dependencies.userDataStore = dependencies.userDataStore
        self.dependencies.style = dependencies.style
        self.dependencies.packageDataStore = dependencies.packageDataStore
        self.dependencies.boltonDataStore = dependencies.boltonDataStore
        self.dependencies.videoChatProvider = dependencies.videoChatProvider
        self.dependencies.rtcManager = dependencies.rtcManager
        sessionsManager = SessionsManager(dependencies)
        sessionsManager.fetchSessions()
        
        startTherapistChatPage()
    }
}


//MARK: - Navigation
extension GetMoreHelpFlow {
    
    fileprivate func startTherapistChatPage() {
        var wireframe = TherapistChatFactory.wireframe()
        wireframe.delegate = self
        wireframe.start(dependencies)
    }
    
    fileprivate func moveToQuestionnairePage(for questionnaireIds: [QuestionnaireBotIdType]) {
        questionnaireBotWireframe = QuestionnaireBotFactory.wireframe()
        questionnaireBotWireframe?.delegate = self
        questionnaireBotWireframe?.start(dependencies,
                                         questionnaireIds: questionnaireIds,
                                         endMessage: NSLocalizedString("Thank You!", comment: ""),
                                         endWait: 2,
                                         allowUserToClose: true,
                                         shouldAutomaticallyClose: false,
                                         title: NSLocalizedString("Questionnaire", comment: ""))
    }
    
    fileprivate func moveToTeamOverviewPage() {
        TeamOverviewFactory.wireframe().start(dependencies)
    }
    
    fileprivate func moveToBuyBoltonsPage() {
        paymentFlow = PaymentFlow()
        paymentFlow?.delegate = self
        paymentFlow?.start(dependencies, type: .boltons)
    }
    
    fileprivate func moveToVideoChatPage() {
        VideoChatFactory.wireframe().start(dependencies)
    }
}

//MARK: - TherapistChatWireframeDelegate
extension GetMoreHelpFlow : TherapistChatWireframeDelegate {

    func therapistChatWireframe(_ sender: TherapistChatWireframe, wantsToPresentQuestionnairePageWith questionnaireIds: [QuestionnaireBotIdType]) {
        moveToQuestionnairePage(for: questionnaireIds)
    }
    
    func therapistChatWireframe(_ sender: TherapistChatWireframe, wantsToPresentDetailsFor assignedTeamMember: TeamMember) {
        
    }
    
    func therapistChatWireframeWantsToPresentTeamOverviewPage(_ sender: TherapistChatWireframe) {
        moveToTeamOverviewPage()
    }
    
    func therapistChatWireframe(_ sender: TherapistChatWireframe, wantsToCloseQuestionnairePageWith message: String) {
        
        guard questionnaireBotWireframe != nil else { return }
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel) { [weak self] _ in
            self?.questionnaireBotWireframe?.finish()
        }
        
        alert.addAction(okAction)
        UIApplication.shared.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    func therapistChatWireframeWantsToPresentBuyBoltonsPage(_ sender: TherapistChatWireframe) {
        moveToBuyBoltonsPage()
    }
    
    func therapistChatWireframe(_ sender: TherapistChatWireframe, wantsToPresentVideoPageWith session: Session) {
        dependencies.session = session
        moveToVideoChatPage()
    }
}

//MARK: - QuestionnaireBotWireframeDelegate
extension GetMoreHelpFlow : QuestionnaireBotWireframeDelegate {
    public func questionnaireBotWireframeDidFinish(_ sender: QuestionnaireBotWireframe) {
        questionnaireBotWireframe = nil
    }
}

extension GetMoreHelpFlow : PaymentFlowDelegate {
    public func paymentFlowDidFinish(_ sender: PaymentFlow) {
        paymentFlow = nil
    }
}

//MARK: - Dependencies
struct GetMoreHelpFlowFlowDependencies : HasNetworkManager, HasNavigationController, HasUserDataStore, HasStyle, HasPackageDataStore, HasBoltonDataStore, HasSession, HasVideoChatProvider, HasRTCManager {
    var networkManager: NetworkManager!
    var navigationController: UINavigationController!
    var userDataStore: UserDataStore!
    var style: Style!
    var packageDataStore: PackageDataStore!
    var boltonDataStore: BoltonDataStore!
    var session: Session!
    var videoChatProvider: VideoChatProvider.Type!
    var rtcManager: RTCManager!
}

