//
//  TeamOverviewInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 23/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit


//MARK: - Interactor

protocol TeamOverviewInteractor {
    
    func fetchTeamMembers(handler: @escaping ([TeamMember]) -> Void)
}

//MARK: - Presenter

protocol TeamOverviewPresenterDelegate : class {
    func teamOverviewPresenter(_ sender: TeamOverviewPresenter, didUpdate teamMembers: [TeamMemberOverviewDispalyData])
    func teamOverviewPresenter(_ sender: TeamOverviewPresenter, wantsToShowActivity inProgress: Bool)
}

protocol TeamOverviewPresenter {
    
    weak var delegate : TeamOverviewPresenterDelegate? { get set }
    
    func startTeamMemberFetch()
}

//MARK: - Wireframe

protocol TeamOverviewWireframeDelegate : class {
    
}

protocol TeamOverviewWireframe {
    
    weak var delegate : TeamOverviewWireframeDelegate? { get set }
    
    func start(_ dependencies: HasNavigationController & HasStyle & HasNetworkManager)
}
