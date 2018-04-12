//
//  EmergencyContactWireframe.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 28/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class EmergencyContactWireframeImplementation : EmergencyContactWireframe {
    
    weak var delegate : EmergencyContactWireframeDelegate?
    
    
    func start(_ dependencies: HasNavigationController & HasNetworkManager & HasStoryboard & HasUserDataStore & HasPayable & HasStyle) {
        
        var moduleDependencies = EmergencyContactDependencies()
        moduleDependencies.emergencyContactWireframe = self
        moduleDependencies.payable = dependencies.payable
        moduleDependencies.userDataStore = dependencies.userDataStore
        moduleDependencies.paymentManager = PaymentManager(userDataStore: moduleDependencies.userDataStore,
                                                           networkManager: dependencies.networkManager)
        moduleDependencies.emergencyContactInteractor = EmergencyContactFactory.interactor(moduleDependencies)
        
        var presenter = EmergencyContactFactory.presenter(moduleDependencies)
        
        let viewController: EmergencyContactViewController = dependencies.storyboard.viewController()
        viewController.title = NSLocalizedString("Details", comment: "")
        viewController.presenter = presenter
        viewController.style = dependencies.style
        
        presenter.delegate = viewController
        
        dependencies.navigationController.mfl_show(viewController, sender: self)
    }
    
    func showPayWithCardPage(for payable: Payable) {
        delegate?.emergencyContactWireframe(self, wantsToShowPayWithCardPageFor: payable)
    }
    
    func finish() {
        delegate?.emergencyContactWireframeWantsToFinish(self)
    }
}


