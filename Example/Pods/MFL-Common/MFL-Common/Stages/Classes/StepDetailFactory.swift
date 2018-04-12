//
//  FileFactory.swift
//  Pods
//
//  Created by Marc Blasi on 04/10/2017.
//
//

import Foundation

protocol HasStepDetailInteractor {
    var interactor : StepDetailInteractor! { get }
}

protocol HasStepDetailWireframe {
    var wireframe: StepDetailWireframe! { get }
}


class StepDetailFactory {
    
    class func wireframe() -> StepDetailWireframe {
        return StepDetailWireframeImplementation()
    }
    
    class func interactor(stageDataStore: StageDataStore) -> StepDetailInteractor {
        return StepDetailInteractorImplementation(dataStore: stageDataStore)
    }
    
    class func presenter(_ dependencies: StageDetailDependencies, step: StepPage) -> StepDetailPresenter {
        return StepDetailPresenterImplementation(dependencies, step: step)
    }
}

struct StageDetailDependencies : HasStepDetailInteractor, HasStepDetailWireframe {
    var wireframe: StepDetailWireframe!
    var interactor: StepDetailInteractor!
}
