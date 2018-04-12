//
//  GoalsWireframe.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 13/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class GoalsWireframeImplementation : GoalsWireframe {
    
    weak var delegate : GoalsWireframeDelegate?
    
    func start(_ dependencies: HasNavigationController & HasStoryboard & HasGoalDataStore & HasStyle) {
        
        let interactor = GoalsFactory.interactor(goalDataStore: dependencies.goalDataStore)
        var presenter = GoalsFactory.presenter(interactor: interactor, wireframe: self)
        
        let viewController: GoalsViewController = dependencies.storyboard.viewController()
        viewController.title = NSLocalizedString("Goals", comment: "")
        
        viewController.presenter = presenter
        viewController.style = dependencies.style
        presenter.delegate = viewController
        
        dependencies.navigationController.mfl_show(viewController, sender: self)
    }
    
    func presentNewGoalPage() {
        delegate?.goalsWireframeWantsToPresentNewGoalPage(self)
    }
    
    func presentGoalDetailsPage(for goal: Goal) {
        delegate?.goalsWireframe(self, wantsToPresentDetailsPageFor: goal)
    }
}


