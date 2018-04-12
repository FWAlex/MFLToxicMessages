//
//  FinkelhorDetailFactory.swift
//  Pods
//
//  Created by Alex Miculescu on 28/11/2017.
//
//

import Foundation

protocol HasFinkelhorDetailInteractor {
    var interactor : FinkelhorDetailInteractor! { get }
}

protocol HasFinkelhorDetailWireframe {
    var wireframe: FinkelhorDetailWireframe! { get }
}


class FinkelhorDetailFactory {
    
    class func wireframe() -> FinkelhorDetailWireframe {
        return FinkelhorDetailWireframeImplementation()
    }
    
    class func interactor() -> FinkelhorDetailInteractor {
        return FinkelhorDetailInteractorImplementation()
    }
    
    class func presenter(_ dependencies: FinkelhorDetailDependencies, category: FinkelhorCategory) -> FinkelhorDetailPresenter {
        return FinkelhorDetailPresenterImplementation(dependencies, category: category)
    }
}

struct FinkelhorDetailDependencies : HasFinkelhorDetailInteractor, HasFinkelhorDetailWireframe {
    var wireframe: FinkelhorDetailWireframe!
    var interactor: FinkelhorDetailInteractor!
}
