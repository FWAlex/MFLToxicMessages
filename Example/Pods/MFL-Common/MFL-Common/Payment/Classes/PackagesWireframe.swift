//
//  PackagesWireframe.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 07/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class PackagesWireframeImplementation : PackagesWireframe {
    
    weak var delegate : PackagesWireframeDelegate?
    weak var navigationController : UINavigationController?
    var transitioningDelegate : SlideUpTransitionAnimator?
    
    func start(_ dependencies: HasNavigationController & HasNetworkManager & HasStoryboard & HasPackageDataStore & HasUserDataStore & HasStyle) -> UINavigationController? {
        return start(dependencies, currentPackageId: nil)
    }
    
    func start(_ dependencies: HasNavigationController & HasNetworkManager & HasStoryboard & HasPackageDataStore & HasUserDataStore & HasStyle, currentPackageId: String?) -> UINavigationController? {
        navigationController = dependencies.navigationController
        
        var moduleDependencies = PackagesDependencies()
        moduleDependencies.packageDataStore = dependencies.packageDataStore
        moduleDependencies.paymentManager = PaymentManager(userDataStore: dependencies.userDataStore,
                                                           networkManager: dependencies.networkManager)
        moduleDependencies.packagesInteractor = PackagesFactory.interactor(moduleDependencies)
        moduleDependencies.packagesWireframe = self
        
        var presenter = PackagesFactory.presenter(moduleDependencies, currentPackageId: currentPackageId)
        
        let viewController: PackagesViewController = dependencies.storyboard.viewController()
        viewController.title = NSLocalizedString("Choose Subscription", comment: "")
        viewController.style = dependencies.style
        
        viewController.presenter = presenter
        presenter.delegate = viewController
        
        transitioningDelegate = SlideUpTransitionAnimator()
        return navigationController?.mfl_present(viewController, transitioningDelegate: transitioningDelegate, navigationBarClass: MFLCommon.shared.navigationBarClassLight)
    }
    
    func payWithCard(for package: Package) {
        delegate?.packagesWireframe(self, wantsToPayWithCardFor: package)
    }
    
    func presentTermsAndConditions() {
        delegate?.packagesWireframeWantsToPresentTermsAndConditions(self)
    }
    
    func close() {
        
        navigationController?.dismiss(animated: true) { [unowned self] in
            self.delegate?.packagesWireframeDidClose(self)
        }
    }
}

