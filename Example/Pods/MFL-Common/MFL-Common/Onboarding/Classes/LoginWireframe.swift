//
//  LoginWireframe.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 21/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class LoginWireframeImplementation : LoginWireframe {

    weak var delegate: LoginWireframeDelegate?
    
    func start(_ dependencies: HasNavigationController & HasStoryboard & HasNetworkManager & HasUserDataStore & HasStyle) {
        start(dependencies, replacingTop: false)
    }
    
    func start(_ dependencies: HasNavigationController & HasStoryboard & HasNetworkManager & HasUserDataStore & HasStyle, replacingTop: Bool) {
        
        let loginManager = LoginManager(networkManager: dependencies.networkManager, userDataStore: dependencies.userDataStore)
        let interactor = LoginFactory.interactor(loginManager: loginManager, networkManager: dependencies.networkManager)
        var presenter = LoginFactory.presenter(interactor: interactor, wireframe: self)
        
        let viewController = dependencies.storyboard.instantiateViewController(withIdentifier: LoginViewController.name) as! LoginViewController
        viewController.style = dependencies.style
        
        viewController.presenter = presenter
        presenter.delegate = viewController
        
        dependencies.navigationController.mfl_show(viewController, sender: self, replaceTop: replacingTop)
    }
    
    func continueJourney(with user: User) {
        delegate?.loginWireframe(self, wantsToContinueJourneyWith: user)
    }
    
    func presentSignUpPage() {
        delegate?.loginWireframeWantsPresentSignUpPage(self)
    }
}
