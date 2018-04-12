//
//  StagesWireframe.swift
//  MFLRecovery
//
//  Created by Marc Blasi on 10/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import MFL_Common

class StagesWireframeImplementation: StagesWireframe {
    
    weak var delegate : StagesWireframeDelegate?
    fileprivate var presenter: StagesPresenter?
    
    func start(_ dependencies: HasNavigationController & HasStoryboard & HasNetworkManager & HasStyle & HasStageDataStore & HasUserDataStore) {
        let stagesDependencies = StagesDependencies(navigationController: dependencies.navigationController, storyboard: dependencies.storyboard, networkManager: dependencies.networkManager, style: dependencies.style, stageDataStore: dependencies.stageDataStore, userDataStore: dependencies.userDataStore)
        let interactor = StagesFactory.interactor(stagesDependencies)
        presenter = StagesFactory.presenter(interactor: interactor, wireframe: self, dependencies: stagesDependencies)
        
        let viewController: StagesViewController = dependencies.storyboard.viewController()
        viewController.style = dependencies.style
        viewController.title = NSLocalizedString("Stages", comment: "")
        viewController.presenter = presenter
        
        dependencies.navigationController.viewControllers = [viewController]
    }
    
    func presentSelectStage(currentStage: Stage) {
        delegate?.presentSelectStage(currentStage: currentStage)
    }
    
    func presentDetailStep(currentStep: StepPage) {
        delegate?.presentDetailStep(currentStep: currentStep)
    }
    
    func stageHaveChange(currentStage: Stage) {
        self.presenter?.stage = currentStage
        self.presenter?.needToResetTheWheel = true
    }
    
    func presentSubscription() {
        delegate?.presentSubscription(self)
    }
    
    func presentAssessment(step: StepAssessments) {
        delegate?.presentAssessments(stepAssessment: step)
    }
}
