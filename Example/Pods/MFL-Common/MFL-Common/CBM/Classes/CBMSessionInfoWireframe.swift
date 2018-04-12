//
//  CBMSessionInfoWireframe.swift
//  Pods
//
//  Created by Alex Miculescu on 08/03/2018.
//
//

import UIKit

class CBMSessionInfoWireframeImplementation : CBMSessionInfoWireframe {
    
    private lazy var storyboard : UIStoryboard = { UIStoryboard(name: "CBM", bundle: .cbm) }()
    
    func viewController(_ dependencies: HasNetworkManager & HasStyle, uuid: String, actions: CBMSessionInfoActions?) -> UIViewController {
        var moduleDependencies = CBMSessionInfoDependencies()
        moduleDependencies.presenter = CBMSessionInfoFactory.presenter()
        moduleDependencies.cbmDataStore = DataStoreFactory.cbmDataStore(dependencies)
        
        let interactor = CBMSessionInfoFactory.interactor(moduleDependencies, uuid: uuid, actions: actions)
        
        let viewController: CBMSessionInfoViewController = storyboard.viewController()
        viewController.interactor = interactor
        viewController.style = dependencies.style
        
        moduleDependencies.presenter.delegate = viewController
        
        return viewController
    }
}


