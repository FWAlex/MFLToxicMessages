//
//  GroundingFactory.swift
//  Pods
//
//  Created by Alex Miculescu on 26/09/2017.
//
//

import Foundation

protocol HasGroundingWireframe {
    var wireframe: GroundingWireframe! { get }
}

public class GroundingFactory {
    
    public class func wireframe() -> GroundingWireframe {
        return GroundingWireframeImplementation()
    }
    
    class func presenter(_ dependencies: GroundingDependencies, items: [GroundingItem]) -> GroundingPresenter {
        return GroundingPresenterImplementation(dependencies, items: items)
    }
}

struct GroundingDependencies :  HasGroundingWireframe {
    var wireframe: GroundingWireframe!
}
