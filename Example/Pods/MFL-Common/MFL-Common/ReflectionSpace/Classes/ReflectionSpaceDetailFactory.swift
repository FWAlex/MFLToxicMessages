//
//  ReflectionSpaceDetailFactory.swift
//  Pods
//
//  Created by Alex Miculescu on 06/10/2017.
//
//

import Foundation

protocol HasReflectionSpaceDetailInteractor {
    var interactor : ReflectionSpaceDetailInteractor! { get }
}

protocol HasReflectionSpaceDetailWireframe {
    var wireframe: ReflectionSpaceDetailWireframe! { get }
}


class ReflectionSpaceDetailFactory {
    
    class func wireframe() -> ReflectionSpaceDetailWireframe {
        return ReflectionSpaceDetailWireframeImplementation()
    }
    
    class func interactor() -> ReflectionSpaceDetailInteractor {
        return ReflectionSpaceDetailInteractorImplementation()
    }
    
    class func presenter(_ dependencies: ReflectionSpaceDetailDependencies, item: ReflectionSpaceItemType) -> ReflectionSpaceDetailPresenter {
        return ReflectionSpaceDetailPresenterImplementation(dependencies, item: item)
    }
}

struct ReflectionSpaceDetailDependencies : HasReflectionSpaceDetailInteractor, HasReflectionSpaceDetailWireframe {
    var wireframe: ReflectionSpaceDetailWireframe!
    var interactor: ReflectionSpaceDetailInteractor!
}
