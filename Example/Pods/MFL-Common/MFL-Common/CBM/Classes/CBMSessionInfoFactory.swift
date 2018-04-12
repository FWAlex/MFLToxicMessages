//
//  CBMSessionInfoFactory.swift
//  Pods
//
//  Created by Alex Miculescu on 08/03/2018.
//
//

import Foundation

protocol HasCBMSessionInfoPresenter {
    var presenter : CBMSessionInfoPresenter! { get }
}

class CBMSessionInfoFactory {
    
    class func wireframe() -> CBMSessionInfoWireframe {
        return CBMSessionInfoWireframeImplementation()
    }
    
    class func interactor(_ dependencies: CBMSessionInfoDependencies, uuid: String, actions: CBMSessionInfoActions?) -> CBMSessionInfoInteractor {
        return CBMSessionInfoInteractorImplementation(dependencies, uuid: uuid, actions: actions)
    }
    
    class func presenter() -> CBMSessionInfoPresenter {
        return CBMSessionInfoPresenterImplementation()
    }
}

struct CBMSessionInfoDependencies : HasCBMSessionInfoPresenter, HasCBMDataStore {
    var presenter: CBMSessionInfoPresenter!
    var cbmDataStore: CBMDataStore!
}
