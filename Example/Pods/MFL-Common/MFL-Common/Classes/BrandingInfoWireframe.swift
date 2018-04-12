//
//  BrandingInfoWireframe.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 14/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class BrandingInfoWireframeImplementation : BrandingInfoWireframe {
    
    weak var delegate : BrandingInfoWireframeDelegate?
    var storyboard = UIStoryboard(name: "Common", bundle: .common)
    
    weak var navigationController : UINavigationController!
    var transitioningDelegate : SlideUpTransitionAnimator?
    
    func start(_ dependencies: HasNavigationController & HasNetworkManager & HasStyle, type: BrandingInfoType) {
        start(dependencies, type: type, asPush: false)
    }
    
    func start(_ dependencies: HasNavigationController & HasNetworkManager & HasStyle, type: BrandingInfoType, asPush: Bool) {
        navigationController = dependencies.navigationController
        
        var moduleDependencies = BrandingInfoDependencies()
        moduleDependencies.wireframe = self
        moduleDependencies.networkManager = dependencies.networkManager
        moduleDependencies.interactor = BrandingInfoFactory.interactor(moduleDependencies)
        
        var presenter = BrandingInfoFactory.presenter(moduleDependencies, type: type)
        let viewController: BrandingInfoViewController = storyboard.viewController()
        viewController.title = type.title
        viewController.style = dependencies.style
        viewController.presenter = presenter
        viewController.isModal = !asPush
        presenter.delegate = viewController

        if asPush {
            navigationController.mfl_show(viewController, sender: self)
        } else {
            transitioningDelegate = SlideUpTransitionAnimator()
            navigationController.mfl_present(viewController,
                                             transitioningDelegate: transitioningDelegate,
                                             navigationBarClass: MFLCommon.shared.navigationBarClassLight)
        }
    }
    
    func close() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}

fileprivate extension BrandingInfoType {
    
    var title : String {
        switch self {
        case .termsAndConditions: return NSLocalizedString("Terms and Conditions", comment: "")
        case .aboutUs: return NSLocalizedString("About Us", comment: "")
        }
    }
}


