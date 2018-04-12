//
//  ReflectionSpaceFactory.swift
//  Pods
//
//  Created by Alex Miculescu on 03/10/2017.
//
//

import Foundation

protocol HasReflectionSpaceInteractor {
    var interactor : ReflectionSpaceInteractor! { get }
}

protocol HasReflectionSpaceWireframe {
    var wireframe: ReflectionSpaceWireframe! { get }
}


public class ReflectionSpaceFactory {
    
    public class func wireframe() -> ReflectionSpaceWireframe {
        return ReflectionSpaceWireframeImplementation()
    }
    
    class func interactor(_ dependencies: HasReflectionSpaceItemDataStore) -> ReflectionSpaceInteractor {
        return ReflectionSpaceInteractorImplementation(dependencies)
    }
    
    class func presenter(_ dependencies: ReflectionSpaceDependencies) -> ReflectionSpacePresenter {
        return ReflectionSpacePresenterImplementation(dependencies)
    }
}

struct ReflectionSpaceDependencies : HasReflectionSpaceInteractor, HasReflectionSpaceWireframe, HasReflectionSpaceItemDataStore {
    var wireframe: ReflectionSpaceWireframe!
    var interactor: ReflectionSpaceInteractor!
    var reflectionSpaceItemDataStore: ReflectionSpaceItemDataStore!
}
