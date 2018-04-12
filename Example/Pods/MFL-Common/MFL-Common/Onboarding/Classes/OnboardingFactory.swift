//
//  OnboardingFactory.swift
//  Pods
//
//  Created by Alex Miculescu on 18/09/2017.
//
//

import Foundation

protocol HasOnboardingWireframe {
    var wireframe: OnboardingWireframe! { get }
}


open class OnboardingFactory {
    
    open class func wireframe() -> OnboardingWireframe {
        return OnboardingWireframeImplementation()
    }
    
    class func presenter(_ dependencies: OnboardingDependencies, copy: OnboardingCopy) -> OnboardingPresenter {
        return OnboardingPresenterImplementation(dependencies, copy: copy)
    }
}

struct OnboardingDependencies : HasOnboardingWireframe {
    var wireframe: OnboardingWireframe!
}
