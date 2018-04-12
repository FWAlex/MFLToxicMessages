//
//  LockedForumWireframe.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 24/10/2017.
//Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class LockedForumWireframeImplementation : LockedForumWireframe {
    
    weak var delegate : LockedForumWireframeDelegate?
    
    func start(_ dependencies: HasStoryboard & HasNavigationController & HasStoryboard & HasStyle, asPush: Bool) {
        var moduleDependencies = LockedForumDependencies()
        moduleDependencies.wireframe = self
        moduleDependencies.interactor = LockedForumFactory.interactor()
        
        var presenter = LockedForumFactory.presenter(moduleDependencies)
        let viewController: LockedForumViewController = dependencies.storyboard.viewController()
        
        viewController.title = NSLocalizedString("Forum", comment: "")
        viewController.presenter = presenter
        viewController.style = dependencies.style
        presenter.delegate = viewController
        
        if asPush {
            dependencies.navigationController.mfl_show(viewController, sender: self, replaceTop: true)
        } else {
            dependencies.navigationController.viewControllers = [viewController]
        }
    }
    
    func presentPackages() {
        delegate?.lockedForumWireframeWantsToPresentPackagesPage(self)
    }
}

