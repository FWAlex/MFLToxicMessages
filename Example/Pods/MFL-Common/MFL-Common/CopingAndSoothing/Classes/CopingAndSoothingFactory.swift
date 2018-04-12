//
//  CopingAndSoothingFactory.swift
//  Pods
//
//  Created by Alex Miculescu on 23/10/2017.
//
//

import Foundation

protocol HasCopingAndSoothingInteractor {
    var interactor : CopingAndSoothingInteractor! { get }
}

protocol HasCopingAndSoothingWireframe {
    var wireframe: CopingAndSoothingWireframe! { get }
}


class CopingAndSoothingFactory {
    
    class func wireframe() -> CopingAndSoothingWireframe {
        return CopingAndSoothingWireframeImplementation()
    }
    
    class func interactor(_ dependencies: CopingAndSoothingDependencies) -> CopingAndSoothingInteractor {
        return CopingAndSoothingInteractorImplementation(dependencies)
    }
    
    class func presenter(_ dependencies: CopingAndSoothingDependencies) -> CopingAndSoothingPresenter {
        return CopingAndSoothingPresenterImplementation(dependencies)
    }
}

struct CopingAndSoothingDependencies : HasCopingAndSoothingInteractor, HasCopingAndSoothingWireframe, HasCSActivityDataStore {
    var wireframe: CopingAndSoothingWireframe!
    var interactor: CopingAndSoothingInteractor!
    var csActivityDataStore: CSActivityDataStore!
}
