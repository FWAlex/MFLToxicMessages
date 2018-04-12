//
//  StagesFlow.swift
//  MFLRecovery
//
//  Created by Marc Blasi on 10/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

public protocol StagesFlowDelegate : class {
    func presentSubscription()
}

public class StagesFlow {
    var stagesWireframe: StagesWireframe!
    
    fileprivate lazy var dependencies : StagesFlowDependencies = {
        var dependencies = StagesFlowDependencies()
        
        dependencies.storyboard = UIStoryboard(name: "Stages", bundle: Bundle.stages)
        return dependencies
    }()
    
    public weak var delegate : StagesFlowDelegate?
    
    public typealias Dependencies = HasNavigationController & HasNetworkManager & HasStyle & HasStagePersistentStore & HasUserDataStore
    
    public init(_ dependencies: Dependencies, localStagesURL: URL) {
        self.dependencies.networkManager = dependencies.networkManager
        self.dependencies.navigationController = dependencies.navigationController
        self.dependencies.style = dependencies.style
        self.dependencies.stageDataStore = DataStoreFactory.stageDataStore(with: dependencies, localStagesURL: localStagesURL)
        self.dependencies.userDataStore = dependencies.userDataStore
        startHomePage()
    }
    
    struct  StagesFlowDependencies : HasNavigationController, HasStoryboard, HasNetworkManager, HasViewController, HasStyle, HasStageSelected, HasStageDataStore, HasUserDataStore {
        var navigationController: UINavigationController!
        var storyboard: UIStoryboard!
        var networkManager: NetworkManager!
        var viewController: UIViewController!
        var style: Style!
        var stage: Stage!
        var stageDataStore: StageDataStore!
        var userDataStore: UserDataStore!
    }
}

//MARK: - Navigation
extension StagesFlow {
    
    func startHomePage() {
        stagesWireframe = StagesFactory.wireframe()
        stagesWireframe.delegate = self
        stagesWireframe.start(self.dependencies)
    }
    
    func startChangeStagePage() {
        var changeStatge = ChangeStageFactory.wireframe()
        changeStatge.delegate = self
        changeStatge.start(self.dependencies)
    }
    
    func startDetailStep(currentStep: StepPage) {
        let detailStep = StepDetailFactory.wireframe()
        detailStep.start(self.dependencies, step: currentStep)
    }
    
    func startAssessment(stepAssessment: StepAssessments) {
        let assessment = QuestionnaireBotFactory.wireframe()
        assessment.start(dependencies,
                         questionnaireIds: [QuestionnaireBotIdType.assessment(json: MFLDefaultJsonDecoder.json(with: stepAssessment.json))],
                         endMessage: nil,
                         endWait: 0,
                         allowUserToClose: true,
                         shouldAutomaticallyClose: false,
                         title: NSLocalizedString("Assessment", comment: ""))
    }
}

extension StagesFlow: StagesWireframeDelegate {
    public func presentSelectStage(currentStage: Stage) {
        self.dependencies.stage = currentStage
        self.startChangeStagePage()
    }
    
    public func presentDetailStep(currentStep: StepPage) {
        startDetailStep(currentStep: currentStep)
    }
    
    public func presentSubscription(_ sender: StagesWireframe) {
        delegate?.presentSubscription()
    }
    
    public func presentAssessments(stepAssessment: StepAssessments) {
        startAssessment(stepAssessment: stepAssessment)
    }
}

extension StagesFlow: ChangeStageWireframeDelegate {
    func didSelectStage(currentStage: Stage) {
        stagesWireframe.stageHaveChange(currentStage: currentStage)
    }
}
