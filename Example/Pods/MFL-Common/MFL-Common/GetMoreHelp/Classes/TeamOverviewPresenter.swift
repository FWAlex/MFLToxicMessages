//
//  TeamOverviewPresenter.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 23/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class TeamOverviewPresenterImplementation: TeamOverviewPresenter {
    
    weak var delegate : TeamOverviewPresenterDelegate?
    
    let interactor: TeamOverviewInteractor
    let wireframe: TeamOverviewWireframe
    
    private var teamMembers = [TeamMember]()
    
    init(_ dependencies: HasTeamOverviewInteractor & HasTeamOverviewWireframe) {
        interactor = dependencies.interactor
        wireframe = dependencies.wireframe
    }
    
    func startTeamMemberFetch() {
        delegate?.teamOverviewPresenter(self, wantsToShowActivity: true)
        interactor.fetchTeamMembers() { [unowned self] teamMembers in
            self.teamMembers = teamMembers
            self.delegate?.teamOverviewPresenter(self, wantsToShowActivity: false)
            self.delegate?.teamOverviewPresenter(self, didUpdate: teamMembers.filter{ $0.isOnline }.map { TeamMemberOverviewDispalyData($0) } )
        }
    }
}

fileprivate extension TeamMemberOverviewDispalyData {
    
    init(_ teamMember: TeamMember) {
        self.imageUrlString = teamMember.avatarURL
    }
}


