//
//  StagesFactory.swift
//  MFLRecovery
//
//  Created by Marc Blasi on 10/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import MFL_Common

public protocol HasStagesInteractor {
    var stagesInteractor: StagesInteractor! { get }
}

public protocol HasStagesWireframe {
    var stagesWireframe: StagesWireframe! { get }
}

public class StagesFactory {
    
    public class func wireframe() -> StagesWireframe {
        return StagesWireframeImplementation()
    }
    
    class func interactor(_ dependencies: StagesDependencies) -> StagesInteractor {
        return StagesInteractorImplementation(dependencies)
    }
    
    class func presenter(interactor: StagesInteractor, wireframe: StagesWireframe, dependencies: StagesDependencies) -> StagesPresenter {
        return StagesPresenterImplementation(interactor: interactor, wireframe: wireframe)
    }
}

public struct StagesDependencies: HasNavigationController, HasStoryboard, HasNetworkManager, HasStyle, HasStageDataStore, HasUserDataStore {
    public var navigationController: UINavigationController!
    public var storyboard: UIStoryboard!
    public var networkManager: NetworkManager!
    public var style: Style!
    public var stageDataStore: StageDataStore!
    public var userDataStore: UserDataStore!
}
