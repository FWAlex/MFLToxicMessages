//
//  OnboardingInterfaces.swift
//  Pods
//
//  Created by Alex Miculescu on 18/09/2017.
//
//

import UIKit

public struct OnboardingCopy {
    public let copyScreen1 : String
    public let copyScreen2 : String
    public let copyScreen3 : String
}

//MARK: - Presenter
protocol OnboardingPresenterDelegate : class {
    
}

protocol OnboardingPresenter {
    
    weak var delegate : OnboardingPresenterDelegate? { get set }
    
    var copyScreen1 : String { get }
    var copyScreen2 : String { get }
    var copyScreen3 : String { get }
    
    func userWantsToContinue()
    func userWantsToSingIn()
}

//MARK: - Wireframe
public protocol OnboardingWireframeDelegate : class {
    func onboardingWireframeWantsToContinue(_ sender: OnboardingWireframe)
    func onboardingWireframeWantsToPresentSignIn(_ sender: OnboardingWireframe)
}

public protocol OnboardingWireframe {
    
    weak var delegate : OnboardingWireframeDelegate? { get set }
    
    func start(_ dependencies: HasNavigationController & HasStyle, copy: OnboardingCopy)
    
    func `continue`()
    func presenToSignIn()
}
