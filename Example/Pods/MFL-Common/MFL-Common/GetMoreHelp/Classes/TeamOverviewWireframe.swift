//
//  TeamOverviewWireframe.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 23/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class TeamOverviewWireframeImplementation : TeamOverviewWireframe {
    
    weak var delegate : TeamOverviewWireframeDelegate?
    fileprivate lazy var storyboard : UIStoryboard = { return UIStoryboard(name: "GetMoreHelp", bundle: .getMoreHelp) }()
    
    func start(_ dependencies: HasNavigationController & HasStyle & HasNetworkManager) {
        var moduleDependencies = TeamOverviewDependencies()
        moduleDependencies.wireframe = self
        moduleDependencies.teamMemberDataStore = DataStoreFactory.teamMemberDataStore(with: dependencies.networkManager)
        moduleDependencies.interactor = TeamOverviewFactory.interactor(moduleDependencies)
        
        var presenter = TeamOverviewFactory.presenter(moduleDependencies)
        let viewController: TeamOverviewViewController = storyboard.viewController()
        viewController.title = NSLocalizedString("Who Reads", comment: "")
        viewController.style = dependencies.style
        
        viewController.presenter = presenter
        presenter.delegate = viewController
        
        dependencies.navigationController.show(viewController, sender: self)
    }
}


