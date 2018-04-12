//
//  StagesPresenter.swift
//  MFLRecovery
//
//  Created by Marc Blasi on 10/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class StagesPresenterImplementation: StagesPresenter {
    weak var delegate : StagesPresenterDelegate?
    let interactor: StagesInteractor
    let wireframe: StagesWireframe
    var needToResetTheWheel: Bool
    
    typealias Dependencies = HasStagesWireframe & HasStagesInteractor 
    
    init(interactor: StagesInteractor, wireframe: StagesWireframe) {
        self.interactor = interactor
        self.wireframe = wireframe
        
        self.needToResetTheWheel = true
    }
    
    var stage: Stage? {
        didSet {
            self.delegate?.presentChangeStage()
        }
    }
    
    func openSelectStages() {
        wireframe.presentSelectStage(currentStage: self.stage!)
    }
    
    var stages: [Stage] {
        return interactor.fetchStages()
    }
    
    func fetchStages() {
        stage = stages.first!
    }
    
    var numberOfStages: Int {
        return stages.count
    }
    
    var numberOfSteps: Int {
        return stage!.steps.count
    }
    
    var stageDisplay: DisplayStage {
        return DisplayStage(self.stage!)
    }
    
    func didSelectStep(index: Int) {
        if self.isLockedStep(at: index) {
            wireframe.presentSubscription()
        }
        else {
            if let stepPage = stage!.steps[index] as? StepPage {
                wireframe.presentDetailStep(currentStep: stepPage)
            }
            else if let stepAssessments = stage!.steps[index] as? StepAssessments {
                wireframe.presentAssessment(step: stepAssessments)
            }
        }
    }
    
    func step(at index: Int) -> StagesStepViewData {
        let step = stage!.steps[index]
        var imageName = step.imageName
        
        if self.isLockedStep(at: index) {
            imageName = "\(imageName)_block"
        }
        
        return StagesStepViewData(imageName: imageName, title: step.title, detail: step.descriptionStep)
    }
    
    func reloadStage() {
        self.delegate?.presentChangeStage()
    }
    
    fileprivate func isLockedStep(at index: Int) -> Bool {
    let step = stage!.steps[index]
        return !mfl_isValid(interactor.user().userPackage) && step.lock == true
    }
}
