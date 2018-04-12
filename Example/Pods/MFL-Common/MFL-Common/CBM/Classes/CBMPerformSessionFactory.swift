//
//  CBMPerformSessionFactory.swift
//  Pods
//
//  Created by Alex Miculescu on 13/03/2018.
//
//

import Foundation

protocol HasCBMPerformSessionPresenter {
    var presenter : CBMPerformSessionPresenter! { get }
}



class CBMPerformSessionFactory {
    
    class func wireframe() -> CBMPerformSessionWireframe {
        return CBMPerformSessionWireframeImplementation()
    }
    
    class func interactor(_ dependencies: CBMPerformSessionDependencies, session: CBMSession, actions: CBMPerformSessionActions?) -> CBMPerformSessionInteractor {
        return CBMPerformSessionInteractorImplementation(dependencies, session: session, actions: actions)
    }
    
    class func presenter() -> CBMPerformSessionPresenter {
        return CBMPerformSessionPresenterImplementation()
    }
}

struct CBMPerformSessionDependencies : HasCBMPerformSessionPresenter, HasCBMDataStore {
    var presenter: CBMPerformSessionPresenter!
    var cbmDataStore: CBMDataStore!
}
