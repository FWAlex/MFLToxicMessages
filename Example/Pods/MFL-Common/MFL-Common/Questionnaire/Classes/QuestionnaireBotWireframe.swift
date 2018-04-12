//
//  QuestionnaireBotWireframe.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 23/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import PKHUD

class QuestionnaireBotWireframeImplementation : QuestionnaireBotWireframe {
    
    weak var delegate : QuestionnaireBotWireframeDelegate?
    
    fileprivate lazy var storyboard : UIStoryboard = {
        return UIStoryboard(name: "Questionnaire", bundle: .questionnaire)
    }()
    
    fileprivate var navCtrl : UINavigationController!
    
    func start(_ dependencies: HasNetworkManager & HasNavigationController & HasStyle,
               questionnaireIds: [QuestionnaireBotIdType],
               endMessage: String?,
               endWait: TimeInterval,
               title: String?) {
        
        start(dependencies,
              questionnaireIds: questionnaireIds,
              endMessage: endMessage,
              endWait: endWait,
              allowUserToClose: false,
              shouldAutomaticallyClose: false,
              title: title)
    }
    
    func start(_ dependencies: HasNetworkManager & HasNavigationController & HasStyle,
               questionnaireIds: [QuestionnaireBotIdType],
               endMessage: String?,
               endWait: TimeInterval,
               allowUserToClose: Bool,
               shouldAutomaticallyClose: Bool,
               title: String?) {
        
        var moduleDependencies = QuestionnaireBotDependencies()
        moduleDependencies.questionnaireBotWireframe = self
        moduleDependencies.questionnaireDataStore = DataStoreFactory.questionnaireDataStore(with: dependencies.networkManager)
        moduleDependencies.questionnaireManager = QuestionnaireManager(moduleDependencies)
        
        var presenter = QuestionnaireBotFactory.presenter(moduleDependencies,
                                                          questionnaireIds: questionnaireIds,
                                                          endMessage: endMessage,
                                                          endWait: endWait,
                                                          shouldAutomaticallyClose: shouldAutomaticallyClose)
        
        let viewController: QuestionnaireBotViewController = storyboard.viewController()
        viewController.title = title
        viewController.allowUserToClose = allowUserToClose
        viewController.style = dependencies.style
        viewController.presenter = presenter
        presenter.delegate = viewController
        
        let enbendingNavController = UINavigationController(navigationBarClass: MFLCommon.shared.navigationBarClassDark,
                                                            toolbarClass: nil)
        enbendingNavController.viewControllers = [viewController]
        dependencies.navigationController.present(enbendingNavController, animated: true)
        navCtrl = dependencies.navigationController
        
    }
    
    func finish() {
        NotificationCenter.default.post(name: MFLDidCompleteQuestionnaire, object: nil, userInfo: nil)
        navCtrl.dismiss(animated: true) { [weak self] in
            if let sself = self {
                sself.delegate?.questionnaireBotWireframeDidFinish(sself)
            }
        }
    }
}


