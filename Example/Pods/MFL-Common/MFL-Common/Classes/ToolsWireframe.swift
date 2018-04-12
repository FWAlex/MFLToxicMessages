  //
//  ToolsWireframe.swift
//  MFLRecovery
//
//  Created by Marc Blasi on 11/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import MFL_Common

class ToolsWireframeImplementation : ToolsWireframe {
    
    weak var delegate : ToolsWireframeDelegate?
    fileprivate var storyboard : UIStoryboard = { return UIStoryboard(name: "Common", bundle: .common) }()
    
    func start(_ dependencies: ToolsWireframeDependencies, tools: [DisplayTool]) {
        
        var moduleDependencies = ToolsDependencies()
        moduleDependencies.userDataStore = dependencies.userDataStore
        moduleDependencies.questionnaireTracker = dependencies.questionnaireTracker
        
        var interactor = ToolsFactory.interactor(moduleDependencies)
        
        moduleDependencies.wireframe = self
        moduleDependencies.interactor = interactor
        
        var presenter = ToolsFactory.presenter(moduleDependencies, tools: tools)
        interactor.presenter = presenter
        
        let viewController: ToolsViewController = storyboard.viewController()
        viewController.title = NSLocalizedString("Tools", comment: "")
        viewController.navigationItem.rightBarButtonItem = dependencies.navigationItem.rightBarButtonItem
        viewController.style = dependencies.style
        viewController.presenter = presenter
        presenter.delegate = viewController
        
        dependencies.navigationController.mfl_show(viewController, sender: self)
    }
    
    func presentTool(index: Int) {
        delegate?.toolsWireframeWantsToPresentToolPage(self, index: index)
    }
    
    func presentSubscription() {
        delegate?.toolsWireframeWantsToSubscription(self)
    }
}


