//
//  CopingAndSoothingDetailFactory.swift
//  Pods
//
//  Created by Alex Miculescu on 26/10/2017.
//
//

import Foundation

protocol HasCopingAndSoothingDetailInteractor {
    var interactor : CopingAndSoothingDetailInteractor! { get }
}

protocol HasCopingAndSoothingDetailWireframe {
    var wireframe: CopingAndSoothingDetailWireframe! { get }
}


class CopingAndSoothingDetailFactory {
    
    class func wireframe() -> CopingAndSoothingDetailWireframe {
        return CopingAndSoothingDetailWireframeImplementation()
    }
    
    class func interactor(_ dependencies: CopingAndSoothingDetailDependencies) -> CopingAndSoothingDetailInteractor {
        return CopingAndSoothingDetailInteractorImplementation(dependencies)
    }
    
    class func presenter(_ dependencies: CopingAndSoothingDetailDependencies, mode: CopingAndSoothingMode, isIntro: Bool) -> CopingAndSoothingDetailPresenter {
        return CopingAndSoothingDetailPresenterImplementation(dependencies, mode: mode, isIntro: isIntro)
    }
}

struct CopingAndSoothingDetailDependencies : HasCopingAndSoothingDetailInteractor, HasCopingAndSoothingDetailWireframe, HasCSActivityDataStore {
    var wireframe: CopingAndSoothingDetailWireframe!
    var interactor: CopingAndSoothingDetailInteractor!
    var csActivityDataStore: CSActivityDataStore!
}
