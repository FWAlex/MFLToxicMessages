//
//  GoalsFactory.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 13/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class GoalsFactory {
    
    class func wireframe() -> GoalsWireframe {
        return GoalsWireframeImplementation()
    }
    
    class func interactor(goalDataStore: GoalDataStore) -> GoalsInteractor {
        return GoalsInteractorImplementation(goalDataStore: goalDataStore)
    }
    
    class func presenter(interactor: GoalsInteractor, wireframe: GoalsWireframe) -> GoalsPresenter {
        return GoalsPresenterImplementation(interactor: interactor, wireframe: wireframe)
    }
}
