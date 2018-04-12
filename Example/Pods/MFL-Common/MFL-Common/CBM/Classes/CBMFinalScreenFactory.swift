//
//  CBMFinalScreenFactory.swift
//  Pods
//
//  Created by Yevgeniy Prokoshev on 19/03/2018.
//
//

import Foundation

protocol HasCBMFinalScreenPresenter {
    var presenter : CBMFinalScreenPresenter! { get }
}

class CBMFinalScreenFactory {
    
    class func wireframe() -> CBMFinalScreenWireframe {
        return CBMFinaScreenWireframeImplementation()
    }
    
    class func interactor(_ dependencies: CBMFinalScreenDependencies, session: CBMSession, actions: CBMFinalScreenActions?) -> CBMFinalScreenInteractor {
        return CBMFinalScreenInteractorImplementation(dependencies, session: session, actions: actions)
    }
    
    class func presenter() -> CBMFinalScreenPresenter {
        return CBMFinalScreenPresenterImplementation()
    }
}

struct CBMFinalScreenDependencies : HasCBMFinalScreenPresenter, HasNetworkManager {
    var presenter: CBMFinalScreenPresenter!
    var networkManager: NetworkManager!
    var cbmDataStore: CBMDataStore!
}
