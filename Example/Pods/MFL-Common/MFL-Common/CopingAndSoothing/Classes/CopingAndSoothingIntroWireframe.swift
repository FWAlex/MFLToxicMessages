//
//  CopingAndSoothingIntroWireframe.swift
//  Pods
//
//  Created by Alex Miculescu on 24/10/2017.
//
//

import UIKit

class CopingAndSoothingIntroWireframeImplementation : CopingAndSoothingIntroWireframe {

    weak var delegate : CopingAndSoothingIntroWireframeDelegate?
    fileprivate lazy var storyboard : UIStoryboard = { return UIStoryboard(name: "CopingAndSoothing", bundle: .copingAndSoothing) }()
    
    func start(_ dependencies: HasNavigationController & HasStyle) {
        var moduleDependencies = CopingAndSoothingIntroDependencies()
        moduleDependencies.wireframe = self
        moduleDependencies.interactor = CopingAndSoothingIntroFactory.interactor()
        
        var presenter = CopingAndSoothingIntroFactory.presenter(moduleDependencies)
        let viewController: CopingAndSoothingIntroViewController = storyboard.viewController()
        viewController.style = dependencies.style
        viewController.title = NSLocalizedString("Coping and Soothing", comment: "")
        viewController.presenter = presenter
        presenter.delegate = viewController

        dependencies.navigationController.mfl_show(viewController, sender: self)
    }
    
    func present(detail mode: CopingAndSoothingMode, completion: @escaping () -> Void) {
        delegate?.copingAndSoothingIntroWireframe(self, wantsToPresentDetail: mode, completion: completion)
    }
    
    func presentCopingAndSoothingPage() {
        delegate?.copingAndSoothingIntroWireframeWantsToPresentCopingAndSoothingPage(self)
    }
}


