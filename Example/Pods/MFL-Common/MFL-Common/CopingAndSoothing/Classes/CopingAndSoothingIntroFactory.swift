//
//  CopingAndSoothingIntroFactory.swift
//  Pods
//
//  Created by Alex Miculescu on 24/10/2017.
//
//

import Foundation

protocol HasCopingAndSoothingIntroInteractor {
    var interactor : CopingAndSoothingIntroInteractor! { get }
}

protocol HasCopingAndSoothingIntroWireframe {
    var wireframe: CopingAndSoothingIntroWireframe! { get }
}


class CopingAndSoothingIntroFactory {
    
    class func wireframe() -> CopingAndSoothingIntroWireframe {
        return CopingAndSoothingIntroWireframeImplementation()
    }
    
    class func interactor() -> CopingAndSoothingIntroInteractor {
        return CopingAndSoothingIntroInteractorImplementation()
    }
    
    class func presenter(_ dependencies: CopingAndSoothingIntroDependencies) -> CopingAndSoothingIntroPresenter {
        return CopingAndSoothingIntroPresenterImplementation(dependencies)
    }
}

struct CopingAndSoothingIntroDependencies : HasCopingAndSoothingIntroInteractor, HasCopingAndSoothingIntroWireframe {
    var wireframe: CopingAndSoothingIntroWireframe!
    var interactor: CopingAndSoothingIntroInteractor!
}
