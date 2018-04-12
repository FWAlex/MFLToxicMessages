//
//  FinkelhorBehaviourWireframe.swift
//  Pods
//
//  Created by Alex Miculescu on 05/12/2017.
//
//

import UIKit

class FinkelhorBehaviourWireframeImplementation : FinkelhorBehaviourWireframe {
    
    weak var delegate : FinkelhorBehaviourWireframeDelegate?
    private lazy var storyboard : UIStoryboard = { return UIStoryboard(name: "ToxicMessages", bundle: .toxicMessages) }()
    
    func viewController(_ dependencies: HasStyle, category: FinkelhorCategory) -> UIViewController {
        var moduleDependencies = FinkelhorBehaviourDependencies()
        moduleDependencies.wireframe = self
        moduleDependencies.interactor = FinkelhorBehaviourFactory.interactor(finkelhorDataStore: DataStoreFactory.finkelhorDataStore())
        
        var presenter = FinkelhorBehaviourFactory.presenter(moduleDependencies, category: category)
        let viewController: FinkelhorBehaviourViewController = storyboard.viewController()
        
        viewController.title = NSLocalizedString("Behaviours", comment: "")
        viewController.presenter = presenter
        viewController.style = dependencies.style
        presenter.delegate = viewController
        
        return viewController
    }
}


