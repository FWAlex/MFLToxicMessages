//
//  ToolsFactory.swift
//  MFLRecovery
//
//  Created by Marc Blasi on 11/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

protocol HasToolsInteractor {
    var interactor : ToolsInteractor! { get }
}

protocol HasToolsWireframe {
    var wireframe: ToolsWireframe! { get }
}


public class ToolsFactory {
    
    public class func wireframe() -> ToolsWireframe {
        return ToolsWireframeImplementation()
    }
    
    class func interactor(_ dependencies: ToolsDependencies) -> ToolsInteractor {
        return ToolsInteractorImplementation(dependencies)
    }
    
    class func presenter(_ dependencies: ToolsDependencies, tools: [DisplayTool]) -> ToolsPresenter {
        return ToolsPresenterImplementation(dependencies, tools: tools)
    }
}

struct ToolsDependencies : HasToolsInteractor, HasToolsWireframe, HasUserDataStore, HasNavigationItem, HasQuestionnaireTracker {
    var wireframe: ToolsWireframe!
    var interactor: ToolsInteractor!
    var userDataStore: UserDataStore!
    var navigationItem: UINavigationItem!
    var questionnaireTracker: QuestionnaireTracker!
}
