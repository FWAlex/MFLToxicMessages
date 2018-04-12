//
//  ChangeStageWireframe.swift
//  Pods
//
//  Created by Marc Blasi on 19/09/2017.
//
//

import UIKit

class ChangeStageWireframeImplementation : ChangeStageWireframe {
    weak var delegate : ChangeStageWireframeDelegate?
    
    func start(_ dependencies: HasNavigationController & HasNetworkManager & HasStoryboard & HasStyle & HasStageSelected & HasStageDataStore) {
        
        let interactor = ChangeStageFactory.interactor(dependencies)
        let changeStageDependency = ChangeStageDependencies(stage: dependencies.stage, changeStageWireframe: self, changeStageInteractor: interactor, stageDataStore: dependencies.stageDataStore)
        
        let viewController: ChangeStageViewController = dependencies.storyboard.viewController()
        
        
        var presenter = ChangeStageFactory.presenter(changeStageDependency)
        viewController.style = dependencies.style
        viewController.title = NSLocalizedString("Change stage", comment: "")
        viewController.presenter = presenter
        
        dependencies.navigationController.pushViewController(viewController, animated: true)
    }
    
    func didSelectStage(currentStage: Stage) {
        self.delegate?.didSelectStage(currentStage: currentStage)
    }
}


