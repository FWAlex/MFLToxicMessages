//
//  QuestionnaireBotFactory.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 23/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

protocol HasQuestionnaireBotWireframe {
    var questionnaireBotWireframe : QuestionnaireBotWireframe! { get }
}

public class QuestionnaireBotFactory {
    
    public class func wireframe() -> QuestionnaireBotWireframe {
        return QuestionnaireBotWireframeImplementation()
    }
    
    class func presenter(_ dependencies: QuestionnaireBotDependencies, questionnaireIds: [QuestionnaireBotIdType], endMessage: String?, endWait: TimeInterval, shouldAutomaticallyClose: Bool) -> QuestionnaireBotPresenter {
        return QuestionnaireBotPresenterImplementation(dependencies, questionnaireIds: questionnaireIds, endMessage: endMessage, endWait: endWait, shouldAutomaticallyClose: shouldAutomaticallyClose)
    }
}

struct QuestionnaireBotDependencies : HasQuestionnaireBotWireframe, HasQuestionnaireManager, HasQuestionnaireDataStore {
    var questionnaireBotWireframe: QuestionnaireBotWireframe!
    var questionnaireManager: QuestionnaireManager!
    var questionnaireDataStore: QuestionnaireDataStore!
}

