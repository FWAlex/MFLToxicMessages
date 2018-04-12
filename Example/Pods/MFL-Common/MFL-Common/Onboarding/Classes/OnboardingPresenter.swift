//
//  OnboardingPresenter.swift
//  Pods
//
//  Created by Alex Miculescu on 18/09/2017.
//
//

import Foundation

class OnboardingPresenterImplementation: OnboardingPresenter {
    
    weak var delegate : OnboardingPresenterDelegate?
    fileprivate let wireframe: OnboardingWireframe
    
    fileprivate let copy : OnboardingCopy
    
    typealias Dependencies = HasOnboardingWireframe
    init(_ dependencies: Dependencies, copy: OnboardingCopy) {
        wireframe = dependencies.wireframe
        self.copy = copy
    }
    
    var copyScreen1 : String { return copy.copyScreen1 }
    var copyScreen2 : String { return copy.copyScreen2 }
    var copyScreen3 : String { return copy.copyScreen3 }
    
    func userWantsToContinue() {
        MFLAnalytics.record(event: .buttonTap(name: "Onboarding Continue Tapped", value: nil))
        wireframe.continue()
    }
    
    func userWantsToSingIn() {
        wireframe.presenToSignIn()
    }
}
