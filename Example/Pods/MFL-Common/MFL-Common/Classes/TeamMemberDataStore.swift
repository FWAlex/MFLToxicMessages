//
//  TeamMemberDataStore.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 23/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

fileprivate let teamMembersRefreshPeriod = TimeInterval(3600 * 24 * 7) // 1 week

class TeamMemberDataStoreImplementation : TeamMemberDataStore {
    
    private let persistentStore : TeamMemberPersistentStore
    private let networkManager : NetworkManager
    
    init(persistentStore: TeamMemberPersistentStore,
         networkManager: NetworkManager) {
        
        self.persistentStore = persistentStore
        self.networkManager = networkManager
    }
    
    init(_ dependencies: HasTeamMemberPersistentStore & HasNetworkManager) {
        persistentStore = dependencies.teamMemberPersistentStore
        networkManager = dependencies.networkManager
    }
    
    func fetchTeamMembers(forced: Bool, handler: @escaping ([TeamMember]) -> Void) {
        
        if shouldFetchTeamMembers() || forced {
            fetchNewTeamMembers(handler: handler)
        } else {
            handler(fetchStoredTeamMembers())
        }
    }
    
    private func fetchNewTeamMembers(handler: @escaping ([TeamMember]) -> Void) {
        
        networkManager.team() { result in
            
            switch result {
                
            case .success(let json):
                handler(self.persistentStore.newTeamMembers(from: json["content"]))
                UserDefaults.mfl_teamMembersRefreshDate = Date().addingTimeInterval(teamMembersRefreshPeriod)
                
            case .failure(let error):
                print(error)
                handler(self.persistentStore.getStoredTeamMembers())
            }
        }
    }
    
    private func fetchStoredTeamMembers() -> [TeamMember] {
        return persistentStore.getStoredTeamMembers()
    }
    
    private func shouldFetchTeamMembers() -> Bool {
        return UserDefaults.mfl_teamMembersRefreshDate < Date()
    }
}

