//
//  FinkelhorBehaviourFactory.swift
//  Pods
//
//  Created by Alex Miculescu on 05/12/2017.
//
//

import Foundation

protocol HasFinkelhorBehaviourInteractor {
    var interactor : FinkelhorBehaviourInteractor! { get }
}

protocol HasFinkelhorBehaviourWireframe {
    var wireframe: FinkelhorBehaviourWireframe! { get }
}


class FinkelhorBehaviourFactory {
    
    class func wireframe() -> FinkelhorBehaviourWireframe {
        return FinkelhorBehaviourWireframeImplementation()
    }
    
    class func interactor(finkelhorDataStore: FinkelhorDataStore) -> FinkelhorBehaviourInteractor {
        return FinkelhorBehaviourInteractorImplementation(finkelhorDataStore: finkelhorDataStore)
    }
    
    class func presenter(_ dependencies: FinkelhorBehaviourDependencies, category: FinkelhorCategory) -> FinkelhorBehaviourPresenter {
        return FinkelhorBehaviourPresenterImplementation(dependencies, category: category)
    }
}

struct FinkelhorBehaviourDependencies : HasFinkelhorBehaviourInteractor, HasFinkelhorBehaviourWireframe {
    var wireframe: FinkelhorBehaviourWireframe!
    var interactor: FinkelhorBehaviourInteractor!
}
