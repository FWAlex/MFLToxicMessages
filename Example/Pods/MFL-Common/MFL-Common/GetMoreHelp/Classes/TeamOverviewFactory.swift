//
//  TeamOverviewFactory.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 23/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

protocol HasTeamOverviewWireframe {
    var wireframe : TeamOverviewWireframe! { get }
}

protocol HasTeamOverviewInteractor {
    var interactor : TeamOverviewInteractor! { get }
}

class TeamOverviewFactory {
    
    class func wireframe() -> TeamOverviewWireframe {
        return TeamOverviewWireframeImplementation()
    }
    
    class func interactor(_ dependencies: TeamOverviewDependencies) -> TeamOverviewInteractor {
        return TeamOverviewInteractorImplementation(dependencies)
    }
    
    class func presenter(_ dependencies: TeamOverviewDependencies) -> TeamOverviewPresenter {
        return TeamOverviewPresenterImplementation(dependencies)
    }
}

struct TeamOverviewDependencies : HasTeamOverviewWireframe, HasTeamOverviewInteractor, HasTeamMemberDataStore {
    var wireframe: TeamOverviewWireframe!
    var interactor: TeamOverviewInteractor!
    var teamMemberDataStore: TeamMemberDataStore!
}
