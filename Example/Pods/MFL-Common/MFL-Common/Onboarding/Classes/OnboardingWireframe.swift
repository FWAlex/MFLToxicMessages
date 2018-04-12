//
//  OnboardingWireframe.swift
//  Pods
//
//  Created by Alex Miculescu on 18/09/2017.
//
//

import UIKit

class OnboardingWireframeImplementation : OnboardingWireframe {
    
    weak var delegate : OnboardingWireframeDelegate?
    
    func start(_ dependencies: HasNavigationController & HasStyle, copy: OnboardingCopy) {
        
        var moduleDependencies = OnboardingDependencies()
        moduleDependencies.wireframe = self
        
        let presenter = OnboardingFactory.presenter(moduleDependencies, copy: copy)
        let viewController: OnboardingViewController = UIStoryboard(name: "Onboarding", bundle: .common).viewController()
        viewController.presenter = presenter
        viewController.style = dependencies.style
        
        dependencies.navigationController.mfl_show(viewController, sender: self)
    }
    
    func `continue`() {
        delegate?.onboardingWireframeWantsToContinue(self)
    }
    
    func presenToSignIn() {
        delegate?.onboardingWireframeWantsToPresentSignIn(self)
    }
}


