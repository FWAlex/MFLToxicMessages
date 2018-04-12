//
//  FileWireframe.swift
//  Pods
//
//  Created by Marc Blasi on 04/10/2017.
//
//

import UIKit

class StepDetailWireframeImplementation : StepDetailWireframe {
    
    weak var delegate : StepDetailWireframeDelegate?
    
    func start(_ dependencies: HasStageDataStore & HasNavigationController & HasStoryboard & HasStyle, step: StepPage) {
        let interactor = StepDetailFactory.interactor(stageDataStore: dependencies.stageDataStore)
        let stepDetailDependencies = StageDetailDependencies(wireframe: self, interactor: interactor)
        var presenter = StepDetailFactory.presenter(stepDetailDependencies, step: step)
        
        let viewController: StepDetailViewController = dependencies.storyboard.viewController()
        viewController.style = dependencies.style
        viewController.title = step.title
        viewController.presenter = presenter
        
        dependencies.navigationController.pushViewController(viewController, animated: true)
    }
}


