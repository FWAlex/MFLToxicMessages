//
//  StagesInterdaces.swift
//  MFLRecovery
//
//  Created by Marc Blasi on 10/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import MFL_Common
//MARK: - Interactor


public protocol StagesInteractor {
    
    func fetchStages() -> [Stage]
    func user() -> User
}

//MARK: - Presenter

protocol StagesPresenterDelegate : class {
    func presentChangeStage()
}

protocol StagesPresenter {
    var stage: Stage? { get set }
    var stageDisplay: DisplayStage { get }
    weak var delegate : StagesPresenterDelegate? { get set }
    var numberOfStages: Int { get }
    var numberOfSteps: Int { get }
    func fetchStages()
    func openSelectStages()
    func didSelectStep(index: Int)
    func step(at indexPath: Int) -> StagesStepViewData
    func reloadStage()
    var needToResetTheWheel: Bool { get set }
}

//MARK: - Wireframe

public protocol StagesWireframeDelegate : class {
    func presentSelectStage(currentStage: Stage)
    func presentDetailStep(currentStep: StepPage)
    func presentSubscription(_ sender: StagesWireframe)
    func presentAssessments(stepAssessment: StepAssessments)
}

public protocol StagesWireframe {
    
    weak var delegate : StagesWireframeDelegate? { get set }
    
    func start(_ dependencies: HasNavigationController & HasStoryboard & HasNetworkManager & HasStyle & HasStageDataStore & HasUserDataStore)
    
    func presentSelectStage(currentStage: Stage)
    
    func presentDetailStep(currentStep: StepPage)
    func presentAssessment(step: StepAssessments)
    
    func stageHaveChange(currentStage: Stage)
    
    func presentSubscription()
}
