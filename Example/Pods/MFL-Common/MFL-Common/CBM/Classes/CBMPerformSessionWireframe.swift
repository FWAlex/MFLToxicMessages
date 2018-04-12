//
//  CBMPerformSessionWireframe.swift
//  Pods
//
//  Created by Alex Miculescu on 13/03/2018.
//
//

import UIKit

class CBMPerformSessionWireframeImplementation : CBMPerformSessionWireframe {
    
    private lazy var storyboard : UIStoryboard = { UIStoryboard(name: "CBM", bundle: .cbm) }()
    
    func viewController(_ dependencies: HasNetworkManager & HasStyle, session: CBMSession, actions: CBMPerformSessionActions?) -> UIViewController {
        
        var moduleDependencies = CBMPerformSessionDependencies()
        moduleDependencies.cbmDataStore = DataStoreFactory.cbmDataStore(dependencies)
        moduleDependencies.presenter = CBMPerformSessionFactory.presenter()
        
        let interactor = CBMPerformSessionFactory.interactor(moduleDependencies,
                                                             session: session,
                                                             actions: actions)
        let viewController: CBMPerformSessionViewController = storyboard.viewController()
        viewController.style = dependencies.style
        
        viewController.interactor = interactor
        moduleDependencies.presenter.delegate = viewController
        
        return viewController
    }
}


