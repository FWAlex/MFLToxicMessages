//
//  FinkelhorDetailWireframe.swift
//  Pods
//
//  Created by Alex Miculescu on 28/11/2017.
//
//

import UIKit

class FinkelhorDetailWireframeImplementation : FinkelhorDetailWireframe {
    
    weak var delegate : FinkelhorDetailWireframeDelegate?
    private lazy var storyboard : UIStoryboard = { return UIStoryboard(name: "ToxicMessages", bundle: .toxicMessages) }()
    
    func viewController(_ dependencies: HasStyle, category: FinkelhorCategory) -> UIViewController {
        var moduleDepenecies = FinkelhorDetailDependencies()
        moduleDepenecies.wireframe = self
        moduleDepenecies.interactor = FinkelhorDetailFactory.interactor()
        
        var presenter = FinkelhorDetailFactory.presenter(moduleDepenecies, category: category)
        let viewController: FinkelhorDetailViewController = storyboard.viewController()
        
        viewController.presenter = presenter
        viewController.style = dependencies.style
        viewController.title = category.title
        
        return viewController
    }
    
    func presentBehaviourPage(for category: FinkelhorCategory) {
        delegate?.finkelhorDetailWireframe(self, wantsToPresentBehaviourPageFor: category)
    }
}

fileprivate extension FinkelhorCategory {
    var title : String {
        switch self {
        case .traumaticSexualisation: return NSLocalizedString("Traumatic Sexualisation", comment: "")
        case .stigmatisation: return NSLocalizedString("Stigmatisation", comment: "")
        case .powerlessness: return NSLocalizedString("Powerlessness", comment: "")
        case .betrayal: return NSLocalizedString("Betrayal", comment: "")
        }
    }
}

