//
//  CBMLoginWireframe.swift
//  Pods
//
//  Created by Alex Miculescu on 07/03/2018.
//
//

import UIKit

class CBMLoginWireframeImplementation : CBMLoginWireframe {
    
    private lazy var storyboard : UIStoryboard = { UIStoryboard(name: "CBM", bundle: .cbm) }()
    
    func viewController(_ dependencies: HasNetworkManager & HasStyle, actions: CBMLoginActions?) -> UIViewController {
        var moduleDependencies = CBMLoginDependencies()
        moduleDependencies.cbmDataStore = DataStoreFactory.cbmDataStore(dependencies)
        moduleDependencies.cbmLoginPresenter = CBMLoginFactory.presenter()
        
        var interactor = CBMLoginFactory.interactor(moduleDependencies, actions: actions)
        let viewController: CBMLoginViewController = storyboard.viewController()
        
        moduleDependencies.cbmLoginPresenter.delegate = viewController
        viewController.interactor = interactor
        viewController.style = dependencies.style
        
        return viewController
    }
}


