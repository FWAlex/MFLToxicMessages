//
//  TeamOverviewInteractor.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 23/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class TeamOverviewInteractorImplementation: TeamOverviewInteractor {
    
    let teamMemberDataStore : TeamMemberDataStore
    
    init(_ dependencies: HasTeamMemberDataStore) {
        teamMemberDataStore = dependencies.teamMemberDataStore
    }
    
    func fetchTeamMembers(handler: @escaping ([TeamMember]) -> Void) {
        teamMemberDataStore.fetchTeamMembers(forced: true, handler: handler)
    }
}

