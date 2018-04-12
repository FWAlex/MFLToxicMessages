//
//  ForumWireframe.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 10/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class ForumWireframeImplementation : ForumWireframe {
 

     weak var delegate : ForumWireframeDelegate?
    
    func start(_ dependencies: HasNavigationController & HasStoryboard & HasQuestionnaireTracker & HasStyle, urlString: String, asPush: Bool) {
        
        var moduleDependencies = ForumDependencies()
        moduleDependencies.questionnaireTracker = dependencies.questionnaireTracker
        moduleDependencies.forumWireframe = self
        var interactor = ForumFactory.interactor(moduleDependencies)

        moduleDependencies.forumInteractor = interactor
        var presenter = ForumFactory.presenter(moduleDependencies, urlString: urlString)
        interactor.presenter = presenter
        
        let viewController: ForumViewController = dependencies.storyboard.viewController()
        viewController.style = dependencies.style
        
        viewController.title = NSLocalizedString("Forum", comment: "")
        viewController.presenter = presenter
        presenter.delegate = viewController
        
        if asPush {
            dependencies.navigationController.mfl_show(viewController, sender: self, replaceTop: true)
        } else {
            dependencies.navigationController.viewControllers = [viewController]
        }
    }
}


