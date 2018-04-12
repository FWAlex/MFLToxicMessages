//
//  ChangeStageFactory.swift
//  Pods
//
//  Created by Marc Blasi on 19/09/2017.
//
//

import Foundation

protocol HasChangeStageInteractor {
    var changeStageInteractor: ChangeStageInteractor! { get }
}

protocol HasChangeStageWireframe {
    var changeStageWireframe: ChangeStageWireframe! { get }
}


class ChangeStageFactory {
    
    class func wireframe() -> ChangeStageWireframe {
        return ChangeStageWireframeImplementation()
    }
    
    class func interactor(_ dependencies: HasStageDataStore) -> ChangeStageInteractor {
        return ChangeStageInteractorImplementation(dataStore: dependencies.stageDataStore)
    }
    
    class func presenter(_ dependencies: ChangeStageDependencies) -> ChangeStagePresenter {
        return ChangeStagePresenterImplementation(dependencies)
    }
}

struct ChangeStageDependencies : HasChangeStageInteractor, HasChangeStageWireframe, HasStageSelected, HasStageDataStore {
    var stage: Stage!
    var changeStageWireframe: ChangeStageWireframe!
    var changeStageInteractor: ChangeStageInteractor!
    var stageDataStore: StageDataStore!
}
