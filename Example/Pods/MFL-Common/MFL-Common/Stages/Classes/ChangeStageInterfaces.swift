//
//  ChangeStageInterfaces.swift
//  Pods
//
//  Created by Marc Blasi on 19/09/2017.
//
//

import UIKit

//MARK: - Interactor


protocol ChangeStageInteractor {
    func fetchStages() -> [Stage]
}

//MARK: - Presenter

protocol ChangeStagePresenterDelegate : class {
    
}

protocol ChangeStagePresenter {
    
    weak var delegate : ChangeStagePresenterDelegate? { get set }
    var numberOfStages : Int { get }
    func stage(at index: Int) -> DisplayStage
    func selectStage(at index: Int)
}

//MARK: - Wireframe

protocol ChangeStageWireframeDelegate : class {
    func didSelectStage(currentStage: Stage)
}

protocol ChangeStageWireframe {
    
    weak var delegate : ChangeStageWireframeDelegate? { get set }
    
    func start(_ dependencies: HasNavigationController & HasStoryboard & HasNetworkManager & HasStyle & HasStageSelected & HasStageDataStore)
    func didSelectStage(currentStage: Stage)
}
