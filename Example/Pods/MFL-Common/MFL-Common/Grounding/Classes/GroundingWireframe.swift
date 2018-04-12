//
//  GroundingWireframe.swift
//  Pods
//
//  Created by Alex Miculescu on 26/09/2017.
//
//

import UIKit

class GroundingWireframeImplementation : GroundingWireframe {
    
    fileprivate lazy var storyboard : UIStoryboard = {
        return UIStoryboard(name: "Grounding", bundle: .grounding)
    }()
    
    weak var delegate : GroundingWireframeDelegate?
    
    func start(_ dependencies: HasNavigationController & HasStyle, items: [GroundingItem]) {
        var moduleDependencies = GroundingDependencies()
        moduleDependencies.wireframe = self
        
        let presenter = GroundingFactory.presenter(moduleDependencies, items: items)
        let viewController: GroundingViewController = storyboard.viewController()
        viewController.title = NSLocalizedString("Grounding", comment: "")
        viewController.presenter = presenter
        viewController.style = dependencies.style
        
        dependencies.navigationController.mfl_show(viewController, sender: self)
    }
}

