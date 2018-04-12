//
//  FinkelhorWireframe.swift
//  Pods
//
//  Created by Alex Miculescu on 27/11/2017.
//
//

import UIKit

class FinkelhorWireframeImplementation : FinkelhorWireframe {
    
    weak var delegate : FinkelhorWireframeDelegate?
    
    fileprivate let storyboard : UIStoryboard = { return UIStoryboard(name: "ToxicMessages", bundle: .toxicMessages) }()
    
    func viewController(_ dependencies: HasStyle) -> UIViewController {
        var moduleDependencies = FinkelhorDependencies()
        moduleDependencies.wireframe = self
        
        var presenter = FinkelhorFactory.presenter(moduleDependencies)
        let viewController: FinkelhorViewController = storyboard.viewController()
        
        viewController.style = dependencies.style
        viewController.presenter = presenter
        viewController.title = NSLocalizedString("Finkelhor Model", comment: "")
        
        presenter.delegate = viewController
        
        return viewController
    }
    
    func presentDetailPage(for category: FinkelhorCategory) {
        delegate?.finkelhorWireframe(self, wantsToPresentDetailPageFor: category)
    }
}


