//
//  CopingAndSoothingWireframe.swift
//  Pods
//
//  Created by Alex Miculescu on 23/10/2017.
//
//

import UIKit

class CopingAndSoothingWireframeImplementation : CopingAndSoothingWireframe {
    
    weak var delegate : CopingAndSoothingWireframeDelegate?
    fileprivate let storyboard = UIStoryboard(name: "CopingAndSoothing", bundle: .copingAndSoothing)
    
    func start(_ dependencies: HasNavigationController & HasStyle & HasNetworkManager, replaceTop: Bool) {
        var moduleDependencies = CopingAndSoothingDependencies()
        moduleDependencies.wireframe = self
        moduleDependencies.csActivityDataStore = DataStoreFactory.csActivityDataStore(networkManager: dependencies.networkManager)
        moduleDependencies.interactor = CopingAndSoothingFactory.interactor(moduleDependencies)
        
        var presenter = CopingAndSoothingFactory.presenter(moduleDependencies)
        let viewController: CopingAndSoothingViewController = storyboard.viewController()
        viewController.style = dependencies.style
        
        viewController.presenter = presenter
        presenter.delegate = viewController
        
        dependencies.navigationController.mfl_show(viewController, sender: self, replaceTop: replaceTop)
    }
    
    func presentCopingAndSoothingDetailPage(for mode: CopingAndSoothingMode) {
        delegate?.copingAndSoothingWireframe(self, wantsToPresentDetailPageFor: mode)
    }
}


