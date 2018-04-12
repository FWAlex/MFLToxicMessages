//
//  TherapistChatWireframe.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 03/04/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class TherapistChatWireframeImplementation : TherapistChatWireframe {
    
    weak var delegate : TherapistChatWireframeDelegate?
    fileprivate lazy var storyboard : UIStoryboard = {
       return UIStoryboard(name: "GetMoreHelp", bundle: .getMoreHelp)
    }()
    
    func start(_ dependencies: HasNavigationController & HasNetworkManager & HasUserDataStore & HasStyle & HasRTCManager) {
        var moduleDependencies = TherapistChatDependencies()
        moduleDependencies.userDataStore = dependencies.userDataStore
        moduleDependencies.therapistChatWireframe = self
        moduleDependencies.rtcManager = dependencies.rtcManager
        moduleDependencies.questionnaireDataStore = DataStoreFactory.questionnaireDataStore(with: dependencies.networkManager)
        
        let interactor = TherapistChatFactory.interactor(moduleDependencies)
        moduleDependencies.therapistChatInteractor = interactor
        
        var presenter = TherapistChatFactory.presenter(&moduleDependencies)
        
        let viewController: TherapistChatViewController = storyboard.viewController()
        viewController.style = dependencies.style
        viewController.presenter = presenter
        presenter.delegate = viewController
        
        viewController.loadViewIfNeeded()
        
        dependencies.navigationController.mfl_show(viewController, sender: self)
    }
    
    func presentTeamOverviewPage() {
        delegate?.therapistChatWireframeWantsToPresentTeamOverviewPage(self)
    }
    
    func presentDetailsFor(_ assignedTeamMember: TeamMember) {
        delegate?.therapistChatWireframe(self, wantsToPresentDetailsFor: assignedTeamMember)
    }
    
    func presentQuestionnairePage(for questionnaireIds: [QuestionnaireBotIdType]) {
        delegate?.therapistChatWireframe(self, wantsToPresentQuestionnairePageWith: questionnaireIds)
    }
    
    func closeQuestionnairePage(message: String) {
        delegate?.therapistChatWireframe(self, wantsToCloseQuestionnairePageWith: message)
    }
    
    func presentBuyBoltonsPage() {
        delegate?.therapistChatWireframeWantsToPresentBuyBoltonsPage(self)
    }
    
    func presentVideoPage(with session: Session) {
        delegate?.therapistChatWireframe(self, wantsToPresentVideoPageWith: session)
    }
}


