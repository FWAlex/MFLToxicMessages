//
//  GoalDetailFactory.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 13/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class GoalDetailFactory {
    
    class func wireframe() -> GoalDetailWireframe {
        return GoalDetailWireframeImplementation()
    }
    
    class func interactor(goalDataStore: GoalDataStore) -> GoalDetailInteractor {
        return GoalDetailInteractorImplementation(goalDataStore: goalDataStore)
    }
    
    class func presenter(goal: Goal?, interactor: GoalDetailInteractor, wireframe: GoalDetailWireframe) -> GoalDetailPresenter {
        return GoalDetailPresenterImplementation(goal: goal, interactor: interactor, wireframe: wireframe)
    }
}
