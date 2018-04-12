//
//  ChangeStagePresenter.swift
//  Pods
//
//  Created by Marc Blasi on 19/09/2017.
//
//

import Foundation

class ChangeStagePresenterImplementation: ChangeStagePresenter {
    weak var delegate : ChangeStagePresenterDelegate?
    fileprivate let interactor: ChangeStageInteractor
    fileprivate let wireframe: ChangeStageWireframe
    var stage: Stage
    var stages: [Stage] {
        return interactor.fetchStages()
    }
    
    typealias Dependencies = HasChangeStageWireframe & HasChangeStageInteractor & HasStageSelected
    init(_ dependencies: Dependencies) {
        interactor = dependencies.changeStageInteractor
        wireframe = dependencies.changeStageWireframe
        stage = dependencies.stage
    }
    
    var numberOfStages: Int {
        return self.stages.count
    }
    
    func stage(at index: Int) -> DisplayStage {
        var displayStage = DisplayStage(stages[index])
        if stages[index].index == stage.index {
            displayStage.selected = true
        }
        return displayStage
    }
    
    func selectStage(at index: Int) {
        stage = self.stages[index]
        wireframe.didSelectStage(currentStage: stage)
    }
}

extension DisplayStage {
    
    init(_ stage: Stage) {
        self.title = stage.title
        self.index = stage.index
    }
}
