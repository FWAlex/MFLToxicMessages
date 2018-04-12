//
//  CBMLoginFactory.swift
//  Pods
//
//  Created by Alex Miculescu on 07/03/2018.
//
//

import Foundation

protocol HasCBMLoginPresenter {
    var cbmLoginPresenter : CBMLoginPresenter! { get }
}

class CBMLoginFactory {
    
    class func wireframe() -> CBMLoginWireframe {
        return CBMLoginWireframeImplementation()
    }
    
    class func interactor(_ dependencies: CBMLoginDependencies, actions: CBMLoginActions?) -> CBMLoginInteractor {
        return CBMLoginInteractorImplementation(dependencies, actions: actions)
    }
    
    class func presenter() -> CBMLoginPresenter {
        return CBMLoginPresenterImplementation()
    }
}

struct CBMLoginDependencies : HasCBMLoginPresenter, HasCBMDataStore {
    var cbmLoginPresenter: CBMLoginPresenter!
    var cbmDataStore: CBMDataStore!
}
