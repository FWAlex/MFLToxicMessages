//
//  RegisterWireframe.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 22/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class RegisterWireframeImplementation : RegisterWireframe {

    weak var delegate : RegisterWireframeDelegate?
    
    func start(_ dependencies: HasStoryboard & HasNavigationController & HasNetworkManager & HasUserDataStore & HasStyle, parentConsentData: ParentConsentData?, registerData: RegisterData) {
        start(dependencies, parentConsentData: parentConsentData, registerData: registerData, replaceTop: false)
    }
    
    func start(_ dependencies: HasStoryboard & HasNavigationController & HasNetworkManager & HasUserDataStore & HasStyle, parentConsentData: ParentConsentData?, registerData: RegisterData, replaceTop: Bool) {
        
        let loginManager = LoginManager(networkManager: dependencies.networkManager, userDataStore: dependencies.userDataStore)
        let interactor = RegisterFactory.interactor(networkManager: dependencies.networkManager, loginManager: loginManager, userDataStore: dependencies.userDataStore)
        var presenter = RegisterFactory.presenter(interactor: interactor, wireframe: self, parentConsentData: parentConsentData, registerData: registerData)
        
        let viewController: RegisterViewController = dependencies.storyboard.viewController()
        
        viewController.presenter = presenter
        viewController.style = dependencies.style
        presenter.delegate = viewController
        
        dependencies.navigationController.mfl_show(viewController, sender: self, replaceTop: replaceTop)
    }
    
    internal func continueJourney(with user: User) {
        delegate?.registerWireframe(self, wantsToContinueJourneyWith: user)
    }
    
    func showTermsAndConditions() {
        delegate?.registerWireframeWantsToShowTermsAndConditions(self)
    }
    
    func presentLogInPage() {
        delegate?.registerWireframeWantsPresentLogInPage(self)
    }
}
