//
//  CMBFinalScreenWireframe.swift
//  MFL-Common
//
//  Created by Yevgeniy Prokoshev on 19/03/2018.
//

import Foundation

class CBMFinaScreenWireframeImplementation: CBMFinalScreenWireframe {
  
    
    private lazy var storyboard : UIStoryboard = { UIStoryboard(name: "CBM", bundle: .cbm) }()
    func viewController(_ dependencies: HasNetworkManager & HasStyle, session: CBMSession, actions: CBMFinalScreenActions?) -> UIViewController {
        
        var moduleDependencies = CBMFinalScreenDependencies()
        moduleDependencies.presenter = CBMFinalScreenFactory.presenter()
        moduleDependencies.networkManager = dependencies.networkManager
        moduleDependencies.cbmDataStore = DataStoreFactory.cbmDataStore(dependencies)
        let interactor = CBMFinalScreenFactory.interactor(moduleDependencies, session: session, actions: actions)
        
        let viewController: CBMFinalScreenViewController = storyboard.viewController()
        viewController.interactor = interactor
        viewController.style = dependencies.style
        
        moduleDependencies.presenter.delegate = viewController
        
        
        return viewController
        
    }
    
}
