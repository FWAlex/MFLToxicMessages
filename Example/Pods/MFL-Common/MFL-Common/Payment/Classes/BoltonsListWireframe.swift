//
//  BoltonsListWireframe.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 02/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class BoltonsListWireframeImplementation : BoltonsListWireframe {
    
    weak var delegate : BoltonsListWireframeDelegate?
    weak var navigationController : UINavigationController?
    var transitioningDelegate : SlideUpTransitionAnimator?
    
    func start(_ dependencies: HasNavigationController & HasStoryboard & HasNetworkManager & HasBoltonDataStore & HasStyle) -> UINavigationController? {
        navigationController = dependencies.navigationController
        
        var moduleDependencies = BoltonsListDependencies()
        moduleDependencies.boltonsListWireframe = self
        moduleDependencies.boltonDataStore = dependencies.boltonDataStore
        moduleDependencies.boltonsListInteractor = BoltonsListFactory.interactor(moduleDependencies)
        
        var presenter = BoltonsListFactory.presenter(moduleDependencies)
        let viewController: BoltonsListViewController = dependencies.storyboard.viewController()
        viewController.style = dependencies.style
        viewController.title = NSLocalizedString("Purchase Video Sessions", comment: "")
        viewController.presenter = presenter
        
        presenter.delegate = viewController
        
        transitioningDelegate = SlideUpTransitionAnimator()
        return navigationController?.mfl_present(viewController, transitioningDelegate: transitioningDelegate, navigationBarClass: MFLCommon.shared.navigationBarClassLight)

    }
    
    func `continue`(with payable: Payable) {
        delegate?.boltonsListWireframe(self, wantsToContinueWith: payable)
    }
    
    func close() {
        
        navigationController?.dismiss(animated: true) { [unowned self] in
            self.delegate?.boltonsListWireframeDidClose(self)
        }
    }
}


