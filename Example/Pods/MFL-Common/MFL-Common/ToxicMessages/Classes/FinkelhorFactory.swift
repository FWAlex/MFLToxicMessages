//
//  FinkelhorFactory.swift
//  Pods
//
//  Created by Alex Miculescu on 27/11/2017.
//
//

import Foundation

protocol HasFinkelhorWireframe {
    var wireframe: FinkelhorWireframe! { get }
}


class FinkelhorFactory {
    
    class func wireframe() -> FinkelhorWireframe {
        return FinkelhorWireframeImplementation()
    }
    
    class func presenter(_ dependencies: FinkelhorDependencies) -> FinkelhorPresenter {
        return FinkelhorPresenterImplementation(dependencies)
    }
}

struct FinkelhorDependencies : HasFinkelhorWireframe {
    var wireframe: FinkelhorWireframe!
}
